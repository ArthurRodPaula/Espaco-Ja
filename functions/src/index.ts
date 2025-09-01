import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
const db = admin.firestore();

export const criarLocacao = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Login necessário.");
  }

  const { localId, inicio, fim, total } = data as {
    localId: string, inicio: string, fim: string, total: number
  };

  const inicioTs = admin.firestore.Timestamp.fromDate(new Date(inicio));
  const fimTs    = admin.firestore.Timestamp.fromDate(new Date(fim));
  if (!localId || !inicio || !fim || fimTs.toMillis() <= inicioTs.toMillis()) {
    throw new functions.https.HttpsError("invalid-argument", "Dados inválidos.");
  }

  const localRef = db.collection("locais").doc(localId);
  const localSnap = await localRef.get();
  if (!localSnap.exists) throw new functions.https.HttpsError("not-found", "Local não encontrado.");
  const local = localSnap.data()!;
  if (local.ativo === false) throw new functions.https.HttpsError("failed-precondition", "Local inativo.");

  const conflitos = await db.collection("locacoes")
    .where("localId", "==", localId)
    .where("status", "in", ["pendente","confirmada"])
    .where("inicio", "<", fimTs)
    .where("fim", ">", inicioTs)
    .limit(1)
    .get();

  if (!conflitos.empty) {
    throw new functions.https.HttpsError("already-exists", "Horário indisponível.");
  }

  const uid = context.auth.uid!;
  const ref = await db.collection("locacoes").add({
    localId,
    ownerUid: local.ownerUid,
    userUid: uid,
    inicio: inicioTs,
    fim: fimTs,
    status: "pendente",
    total,
    criadoEm: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { locacaoId: ref.id, status: "pendente" };
});
