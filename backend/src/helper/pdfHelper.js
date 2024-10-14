const PDFDocument = require("pdfkit");
const fs = require("fs");
const path = require("path");
const { formatDate } = require("./helpers");

// Language Templates (Add your translated templates here)
const contractStaticTemplates = {
  en: `
3. Payment Terms
The Seeker agrees to transfer the Agreed Price into an escrow account managed by the Platform at the beginning of this contract.
The funds will remain in the escrow until the Service is marked as completed by the Seeker and verified by the Provider.
If the Provider successfully completes the Service as agreed, the Seeker must approve the release of payment to the Provider.

4. Completion and Approval
The Provider must complete the Service by the specified Due Date.
Upon completion, the Provider will notify the Seeker through the Platform.
The Seeker must review and either approve or reject the work within [3 days] of submission.
If no response is given within this period, the Platform reserves the right to consider the Service as approved, and the payment will be released to the Provider.

5. Cancellation and Refund Policy
The Seeker may cancel the contract at any time before the Provider starts the work with a full refund.
If the Seeker cancels after the Provider has started, the refund amount will be subject to the Provider's claimed effort and will be decided by the Platform if there is a dispute.
The Provider may also cancel the contract if the Seeker's requests are unreasonable or change beyond the agreed terms.

6. Dispute Resolution
In case of any disputes, both parties agree to submit a claim ticket through the Platform.
The Platform will review the evidence provided by both the Seeker and the Provider and attempt to mediate a fair resolution.
The decision of the Platform will be final, and both parties must abide by the outcome.

7. Liabilities and Waivers
The Platform acts only as an intermediary and is not responsible for the content, quality, or outcomes of the work performed.
Both Seeker and Provider agree to take full responsibility for their roles and any consequences resulting from the work engagement.
Any legal liabilities, if they arise, will be between the Seeker and the Provider unless the Platform is found to be in violation of its own policies.

8. Confidentiality and Data Use
Both parties agree to maintain the confidentiality of any sensitive information exchanged during the performance of the Service.
The Platform will ensure that all personal data is handled according to its privacy policy and is only shared as necessary to fulfill the terms of this contract.

9. Modification of Contract
Any changes to the contract must be agreed upon in writing through the Platform's chat or communication tools.

10. Termination
This contract will terminate automatically when the Service is completed, and the agreed payment is released to the Provider.
Either party can also terminate the contract in the event of a breach of terms, subject to the Platform's final review and judgment.

11. Prohibited Use and Monitoring
Users agree that they will not use the Platform to engage in any illegal, unethical, or harmful activities. This includes, but is not limited to:
Requesting or Offering Illegal Goods or Services (e.g., drugs, weapons, or trafficking).
Sharing Contact Information to bypass the Platform's communication and agreement system.
Soliciting activities that may harm, exploit, or endanger others.
The Platform reserves the right to monitor communications and posted tasks for specific keywords or patterns that may indicate prohibited use.
If any flagged content is found, it will be reviewed by a security team, and the Platform reserves the right to:
Suspend or ban the offending user.
Report suspicious activities to law enforcement authorities, if necessary.
Any attempt to circumvent the Platform's monitoring mechanisms (e.g., by using coded language or altering contact information) will be considered a serious violation and may lead to immediate termination of the user's account.
By using the Platform, both Seekers and Providers agree to abide by this clause and accept that any violation may result in permanent removal from the Platform.

12. Acceptance
By electronically signing this contract, both parties agree to the above terms and conditions. This agreement will be binding as of the date stated at the beginning of the contract.
`,
  fr: `
3. Conditions de Paiement
Le Demandeur s'engage à transférer le Prix Convenu dans un compte séquestre géré par la Plateforme au début de ce contrat.
Les fonds resteront dans le séquestre jusqu'à ce que le Service soit marqué comme terminé par le Demandeur et vérifié par le Prestataire.
Si le Prestataire réalise avec succès le Service convenu, le Demandeur doit approuver la libération du paiement au Prestataire.

4. Finalisation et Approbation
Le Prestataire doit terminer le Service avant la Date de Livraison spécifiée.
Une fois le Service terminé, le Prestataire en informera le Demandeur via la Plateforme.
Le Demandeur doit examiner et approuver ou rejeter le travail dans un délai de [3 jours] à compter de la soumission.
Si aucune réponse n'est donnée dans ce délai, la Plateforme se réserve le droit de considérer le Service comme approuvé, et le paiement sera libéré au Prestataire.

5. Politique d'Annulation et de Remboursement
Le Demandeur peut annuler le contrat à tout moment avant le début du travail par le Prestataire avec un remboursement complet.
Si le Demandeur annule après le début des travaux, le montant du remboursement sera soumis à l'effort déclaré par le Prestataire et sera décidé par la Plateforme en cas de litige.
Le Prestataire peut également annuler le contrat si les demandes du Demandeur sont jugées déraisonnables ou si elles changent de manière significative par rapport aux termes convenus.

6. Résolution des Litiges
En cas de litige, les deux parties s'engagent à soumettre un ticket de réclamation via la Plateforme.
La Plateforme examinera les preuves fournies par le Demandeur et le Prestataire et tentera de trouver une solution équitable.
La décision de la Plateforme sera finale, et les deux parties doivent respecter l'issue de cette décision.

7. Responsabilité et Exonérations
La Plateforme agit uniquement en tant qu'intermédiaire et n'est pas responsable du contenu, de la qualité ou des résultats du travail effectué.
Le Demandeur et le Prestataire conviennent de prendre l'entière responsabilité de leurs rôles et des conséquences découlant de l'engagement de travail.
Toute responsabilité légale, si elle survient, sera entre le Demandeur et le Prestataire, sauf si la Plateforme est reconnue en violation de ses propres politiques.

8. Confidentialité et Utilisation des Données
Les deux parties conviennent de préserver la confidentialité de toute information sensible échangée au cours de la réalisation du Service.
La Plateforme veillera à ce que toutes les données personnelles soient traitées conformément à sa politique de confidentialité et ne soient partagées que dans la mesure nécessaire pour remplir les termes de ce contrat.

9. Modification du Contrat
Toute modification du contrat doit être convenue par écrit via les outils de communication de la Plateforme.

10. Résiliation
Ce contrat prendra fin automatiquement lorsque le Service sera terminé et que le paiement convenu sera libéré au Prestataire.
L'une ou l'autre des parties peut également mettre fin au contrat en cas de violation des termes, sous réserve de l'examen final et du jugement de la Plateforme.

11. Utilisation Prohibée et Surveillance
Les utilisateurs s'engagent à ne pas utiliser la Plateforme pour participer à des activités illégales, contraires à l'éthique ou nuisibles. Cela inclut, mais n'est pas limité à :
Demander ou Offrir des Biens ou Services Illégaux (ex. : drogues, armes ou trafic).
Partager des Informations de Contact pour contourner le système de communication et d'accord de la Plateforme.
Solliciter des activités pouvant nuire, exploiter ou mettre en danger autrui.
La Plateforme se réserve le droit de surveiller les communications et les tâches publiées pour détecter des mots-clés spécifiques ou des schémas pouvant indiquer une utilisation prohibée.
Si un contenu suspect est détecté, il sera examiné par une équipe de sécurité, et la Plateforme se réserve le droit de :
Suspendre ou bannir l'utilisateur concerné.
Signaler les activités suspectes aux autorités compétentes, si nécessaire.
Toute tentative de contourner les mécanismes de surveillance de la Plateforme (ex. : utiliser un langage codé ou modifier les informations de contact) sera considérée comme une violation grave et pourra entraîner la résiliation immédiate du compte de l'utilisateur.
En utilisant la Plateforme, les Demandeurs et les Prestataires s'engagent à respecter cette clause et acceptent que toute violation puisse entraîner une exclusion définitive de la Plateforme.

12. Acceptation
En signant électroniquement ce contrat, les deux parties acceptent les termes et conditions ci-dessus. Cet accord sera contraignant à partir de la date indiquée au début du contrat.
`,
  ar: `
3. شروط الدفع
يوافق الطالب على تحويل السعر المتفق عليه إلى حساب الضمان المُدار بواسطة المنصة في بداية هذا العقد.
ستظل الأموال في حساب الضمان حتى يتم وضع علامة على الخدمة على أنها مكتملة من قبل الطالب ويتم التحقق منها من قبل المزود.
إذا أكمل المزود الخدمة بنجاح وفقًا للاتفاق، يجب على الطالب الموافقة على الإفراج عن الدفعة إلى المزود.

4. الإتمام والموافقة
يجب على المزود إتمام الخدمة بحلول تاريخ الاستحقاق المحدد.
عند الانتهاء، سيقوم المزود بإخطار الطالب عبر المنصة.
يجب على الطالب مراجعة العمل والموافقة عليه أو رفضه خلال [3 أيام] من التقديم.
إذا لم يتم الرد خلال هذه الفترة، تحتفظ المنصة بالحق في اعتبار الخدمة موافق عليها، وسيتم الإفراج عن الدفعة للمزود.
سياسة الإلغاء والاسترداد
يمكن للطالب إلغاء العقد في أي وقت قبل أن يبدأ المزود العمل والحصول على استرداد كامل.
إذا قام الطالب بالإلغاء بعد أن يبدأ المزود العمل، سيكون مبلغ الاسترداد خاضعًا للجهد المُدعى به من قبل المزود، وسيتم اتخاذ القرار من قبل المنصة في حالة حدوث نزاع.
يمكن أيضًا للمزود إلغاء العقد إذا كانت طلبات الطالب غير معقولة أو تغيرت بشكل كبير عن الشروط المتفق عليها.

5. حل النزاعات
في حالة وجود أي نزاعات، يوافق الطرفان على تقديم تذكرة شكوى عبر المنصة.
ستقوم المنصة بمراجعة الأدلة المقدمة من كل من الطالب والمزود ومحاولة التوسط لإيجاد حل عادل.
يكون قرار المنصة نهائيًا، ويجب على الطرفين الالتزام بالنتيجة.

6. المسؤوليات والتنازلات
تعمل المنصة فقط كوسيط وليست مسؤولة عن محتوى أو جودة أو نتائج العمل المنفذ.
يوافق كل من الطالب والمزود على تحمل المسؤولية الكاملة عن أدوارهم وأي عواقب ناتجة عن الالتزام بالعمل.
أي مسؤوليات قانونية، إذا نشأت، ستكون بين الطالب والمزود، إلا إذا تم العثور على أن المنصة قد انتهكت سياساتها الخاصة.

7. السرية واستخدام البيانات
يوافق الطرفان على الحفاظ على سرية أي معلومات حساسة يتم تبادلها أثناء تنفيذ الخدمة.
ستحرص المنصة على أن تتم معالجة جميع البيانات الشخصية وفقًا لسياسة الخصوصية الخاصة بها، ولن يتم مشاركتها إلا بالقدر اللازم للوفاء بشروط هذا العقد.

8. تعديل العقد
يجب الاتفاق على أي تغييرات في العقد كتابيًا عبر أدوات الدردشة أو الاتصال الخاصة بالمنصة.

9. إنهاء العقد
سينتهي هذا العقد تلقائيًا عند الانتهاء من الخدمة وإطلاق الدفعة المتفق عليها إلى المزود.
يمكن لأي من الطرفين أيضًا إنهاء العقد في حالة حدوث خرق للشروط، رهناً بالمراجعة النهائية والحكم من قبل المنصة.

10. الاستخدام المحظور والمراقبة
يوافق المستخدمون على أنهم لن يستخدموا المنصة للمشاركة في أي أنشطة غير قانونية أو غير أخلاقية أو ضارة. يشمل ذلك، على سبيل المثال لا الحصر:
طلب أو تقديم سلع أو خدمات غير قانونية (مثل المخدرات أو الأسلحة أو الاتجار بالبشر).
مشاركة معلومات الاتصال لتجاوز نظام الاتصال والاتفاق الخاص بالمنصة.
تحريض على أنشطة قد تلحق الضرر أو تستغل أو تعرض الآخرين للخطر.
تحتفظ المنصة بالحق في مراقبة الاتصالات والمهام المنشورة لاكتشاف الكلمات الرئيسية أو الأنماط التي قد تشير إلى استخدام محظور.
إذا تم العثور على أي محتوى مشبوه، سيتم مراجعته من قبل فريق الأمن، وتحتفظ المنصة بالحق في:

11. تعليق أو حظر المستخدم المخالف.
إبلاغ السلطات المختصة بالأنشطة المشبوهة إذا لزم الأمر.
أي محاولة للتحايل على آليات المراقبة الخاصة بالمنصة (مثل استخدام لغة مشفرة أو تعديل معلومات الاتصال) ستُعتبر انتهاكًا خطيرًا وقد يؤدي إلى إنهاء فوري لحساب المستخدم.
باستخدام المنصة، يوافق كل من الطالب والمزود على الالتزام بهذا البند ويقبل أن أي انتهاك قد يؤدي إلى الإزالة الدائمة من المنصة.

12. القبول
بتوقيع هذا العقد إلكترونياً، يوافق الطرفان على الشروط والأحكام المذكورة أعلاه. سيكون هذا الاتفاق ملزماً اعتباراً من التاريخ الموضح في بداية العقد.
`,
};
const contractDynamicTemplates = {
  en: (data) => `
Service Agreement Contract

Contract ID: ${data.contractId}
Date: ${data.date}

1. Parties Involved
Seeker Name: ${data.seekerName}
Provider Name: ${data.providerName}
Platform: Ekhdemli

2. Scope of Service
Task Description: ${data.taskDescription}
Expected Deliverables: ${data.deliverables ?? "not provided"}
Delivery Date: ${formatDate(data.deliveryDate)}
Agreed Price: ${data.price} TND
${contractStaticTemplates["en"]}

Seeker's Signature: ${data.seekerName}
Provider's Signature: ${data.providerName}
  `,
  fr: (data) => `
Contrat d'Accord de Service

ID du Contrat : ${data.contractId}
Date : ${data.date}

1. Parties Concernées
Nom du Demandeur : ${data.seekerName}
Nom du Prestataire : ${data.providerName}
Plateforme : Ekhdemli

2. Champ d'Application du Service
Description du Service : ${data.taskDescription}
Livrables attendus : ${data.deliverables ?? "non fourni"}
Date de Livraison : ${formatDate(data.deliveryDate)}
Prix Convenu : ${data.price} TND
${contractStaticTemplates["fr"]}

Signature du Demandeur : __________________
Signature du Prestataire : __________________
  `,
  ar: (data) => `
عقد اتفاقية الخدمة

رقم العقد: ${data.contractId}
التاريخ: ${data.date}

1. الأطراف المعنية
اسم الطالب: ${data.seekerName}
اسم المزود: ${data.providerName}
المنصة: Ekhdemli

2. نطاق الخدمة
وصف الخدمة: ${data.taskDescription}
النتائج المتوقعة: ${data.deliverables ?? "لم يتم توفيره"}
تاريخ التسليم: ${formatDate(data.deliveryDate)}
السعر المتفق عليه: ${data.price} TND
${contractStaticTemplates["ar"]}

توقيع الطالب: __________________
توقيع المزود: __________________
  `,
};

// Function to generate and save PDF
const generateContractPDF = async (data, language = "en") => {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const fileName = `contract_${data.contractId}.pdf`;
    const filePath = path.join(__dirname, "../../public/contracts", fileName);

    // Check and create the contracts folder using absolute path
    const contractDir = path.join(__dirname, "../../public/contracts/");
    if (!fs.existsSync(contractDir)) {
      fs.mkdirSync(contractDir, { recursive: true }); // Ensure the directory exists, recursively creating necessary folders
    }

    // Write the PDF file
    const stream = fs.createWriteStream(filePath);
    doc.pipe(stream);

    // Generate content based on language
    const content = contractDynamicTemplates[language](data);

    console.log(`Contract created ${fileName}`);
    // Add content to PDF
    doc.text(content, {
      align: language == "ar" ? "right" : "left",
    });

    doc.end();

    stream.on("finish", () => {
      resolve(path.join(__dirname, `../../public/contracts/${fileName}`));
    });

    stream.on("error", (err) => {
      reject(err);
    });
  });
};

async function createContract(formData) {
  const contractData = {
    contractId: formData.contractId,
    date: new Date().toLocaleDateString(),
    seekerName: formData.seekerName,
    providerName: formData.providerName,
    taskDescription: formData.taskDescription,
    deliverables: formData.deliverables,
    deliveryDate: formData.deliveryDate,
    price: formData.price,
  };

  try {
    const fileUrl = await generateContractPDF(
      contractData,
      formData.language || "en"
    );
    return fileUrl;
  } catch (error) {
    console.log(`Failed to generate PDF at ${error}`);
    console.error("\x1b[31m%s\x1b[0m", error);
    return undefined;
  }
}

module.exports = {
  createContract,
};
