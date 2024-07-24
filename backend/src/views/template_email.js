const fs = require("fs");
const path = require("path");
const logoPath = path.join(
  __dirname,
  "../../public/images/logo_thelandlord.png"
);
const logoData = fs.readFileSync(logoPath);
const logoBase64 = Buffer.from(logoData).toString("base64");
const logoPathSig = path.join(__dirname, "../../public/images/sign-admin.png");
const logoDataSig = fs.readFileSync(logoPathSig);
const logoBase64Sig = Buffer.from(logoDataSig).toString("base64");

const notificationMessage = (sender, message, property) => `
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }

      h1 {
        font-size: 24px;
        margin-top: 0;
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
      .card {
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .small-image {
        max-width: 100px; /* Set the maximum width of the image */
        height: auto; /* Maintain aspect ratio */
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo">
        <img src="cid:logo_thelandlord" alt="The Landlord" />
      </div>
      <h1>Nouveau message de The Landlord</h1>
      <div class="card">
        <h2>${sender.name}</h2>
        <p>${message}</p>
        <img
          class="small-image"
          src="${property.url}"
          alt="Small Image"
        />
      </div>
      <p>
        Nous avons reçu un nouveau message sur The Landlord. Vous pouvez
        consulter et répondre à ce message en vous connectant à votre compte.
      </p>
      <p>
        Si vous avez des questions ou des préoccupations, n'hésitez pas à nous
        contacter.
      </p>
      <p>
        Merci de votre confiance en The Landlord. Nous sommes là pour vous
        offrir la meilleure expérience possible.
      </p>
      <p>L'équipe de The Landlord</p>
    </div>
  </body>
</html>


`;
const emailReservationForCheckin = (propertyName) => `
<!DOCTYPE html>
<html>
<head>
	<title>Welcome to The Landlord</title>
	<style>
	    body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }
      h1 {
        font-size: 24px;
        margin-top: 0;
        text-align: center;
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
        text-align: center;
        /* color: #2da680; Base Color */
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }

	</style>
</head>
<body>
	<div class="container">		
		<div class="logo">
			<img src="cid:logo_thelandlord" alt="The landlord" />
		</div>
		<h1>Confirmation de votre réservation chez The Landlord</h1>
    
		<p>Au nom de toute l'équipe de The Landlord, j'ai le plaisir de vous confirmer votre réservation pour « ${propertyName}» et de vous souhaiter la bienvenue.</p>
		<p>Pour faciliter votre arrivée et votre séjour, veuillez utiliser le lien suivant pour effectuer votre check-in en ligne. Vous aurez simplement besoin d'entrer votre code de réservation et de suivre les étapes indiquées :
    www.checkin.thelandlord.tn </p>
		<p>Chez The Landlord, nous nous engageons à offrir à nos clients des logements de qualité et un service irréprochable. Votre confort et votre satisfaction sont nos priorités.</p>
		<p>Nous vous invitons également à partager votre expérience en répondant au questionnaire de satisfaction qui vous sera proposé le jour de votre départ. Vos retours sont précieux et nous aident à améliorer continuellement nos services.</p>
		<p>Nous vous souhaitons un agréable séjour et restons à votre disposition pour toute demande ou information complémentaire.</p>
		<p>Cordialement,</p>
		<p>Farouk Ben Achour</p>
		<p>CEO</p>
		<p>Raise your expectations</p>
    
	</div>
</body>
</html>
`;

const newPartnerMail = (email, password) => `
<!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }

      h1 {
        font-size: 24px;
        margin-top: 0;
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
      .card {
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .small-image {
        max-width: 100px; /* Set the maximum width of the image */
        height: auto; /* Maintain aspect ratio */
      }
      .link {
        color: #2da680;
        text-decoration: none;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo">
        <img src="cid:logo_thelandlord" alt="The Landlord" />
      </div>
      <h1>Welcome to The Landlord Partnership</h1>
      <div class="card">
        <p>Dear Partner,</p>
        <p>
          It is with great enthusiasm that we welcome you as our newest partner! This collaboration marks the beginning of a promising journey, and we are committed to ensuring its success. As part of our partnership, we are pleased to provide you with access to our API documentation through Swagger. This tool will facilitate a seamless integration and exploration of our API endpoints, enabling you to leverage the full potential of our services.
        </p>
        <p>
          Please click on the following link to access Swagger and explore our
          API endpoints:
          <a class="link" href="https://api.thelandlord.tn/swagger"
            >Swagger Documentation</a
          >
        </p>
        <p>Here are your login credentials for accessing Swagger:</p>
        <ul>
          <li>Email: ${email}</li>
          <li>Password: ${password}</li>
        </ul>
      </div>
      <p>
       Please follow the provided link to access the Swagger interface and immerse yourself in the comprehensive documentation we have prepared for you. Should you require any assistance or have any questions, do not hesitate to reach out to us.
      </p>
      <p>
        We look forward to a fruitful and enduring partnership.
      </p>
      <p>Best regards,</p>
      <p>The Landlord Team</p>
    </div>
  </body>
</html>

`;

/**
 * Confirmation email after successful reset password
 * @param {String} fullName User full name
 * @param {String} code User full name
 * @returns
 */
const contractMail = (fullName) => `
<!DOCTYPE html>
<html>
<head>
	<title>Contract The Landlord</title>
	<style>
		    body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }
      h1 {
        font-size: 24px;
        margin-top: 0;
        text-align: center;
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
        text-align: center;
        /* color: #2da680; Base Color */
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
	</style>
</head>
<body>
	<div class="container">
		<div class="logo">
			<img src="cid:logoName" alt="landlord logo" />
		</div>
		<h1>Contract The landlord</h1>
		<hr />
	</div>
</body>
</html>

  `;

/**
 * Send Email to reset password
 * @param {String} fullName User full name
 * @param {*} email User email
 * @param {String} API_ENDPOINT Depend on the app running localy or server
 * @param {String} token Generated unique code
 * @returns
 */
const forgotPasswordEmailTemplate = (reset_code) => `
  <!DOCTYPE html>
  <!DOCTYPE html>
<html>
  <head>
    <style>
      body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }
      h1 {
        font-size: 24px;
        margin-top: 0;
        color: #2da680; /* Couleur principale */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
      .card {
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .code {
        font-size: 20px; /* Taille de police plus grande pour une meilleure lisibilité */
        color: #333; /* Couleur foncée pour un contraste élevé avec le code */
        font-weight: bold; /* Gras pour souligner l'importance */
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo">
        <img src="cid:logo_thelandlord" alt="The Landlord" />
      </div>
      <h1>Réinitialisez votre mot de passe</h1>
      <div class="card">
        <p>
          Veuillez utiliser le code suivant pour réinitialiser votre mot de
          passe :
        </p>
        <p class="code">${reset_code}</p>
        <p>
          Ce code expirera dans 30 minutes. Saisissez-le rapidement pour
          réinitialiser votre mot de passe.
        </p>
      </div>
      <p>
        Si vous n'avez pas demandé à réinitialiser votre mot de passe, veuillez
        ignorer cet email ou contactez-nous si vous avez des préoccupations
        concernant la sécurité de votre compte.
      </p>
      <p>
        Merci d'utiliser The Landlord. Nous sommes là pour vous offrir la
        meilleure expérience possible.
      </p>
      <p>L'équipe de The Landlord</p>
    </div>
  </body>
</html>

  `;

/**
 * Confirmation email after successful reset password
 * @param {String} fullName User full name
 * @returns
 */
const resetPasswordConfirmationEmailTemplate = (fullName) => `
  <!DOCTYPE html>
  <html>
    <head>
      <title>
        Confirmation de réinitialisation du mot de passe
      </title>
    </head>
    <body>
      <div>
        <p>Bonjour ${fullName},</p>
        <p>Votre mot de passe a été réinitialisé avec succès.</p>
        <p>
          Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.
        </p>
        <p>Cordialement,</p>
      </div>
      <hr />
    </body>
  </html>
  `;

const sendConfirmationMail = (fullName, token, isMobile) => `
<!DOCTYPE html>
<html>
<head>
	<style>
      body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }

      h1 {
        font-size: 24px;
        margin-top: 0;
        /* text-align: center; */
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
        /* text-align: center; */
        /* color: #2da680; Base Color */
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
      button {
        background-color: #2da680; /* Complementary Color */
        border: none;
        color: #fff;
        padding: 10px 50px;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        display: block;
        margin: 0 auto;
      }
      button:hover {
        background-color: #278eba; /* Accent Color */
      }
      .verification-code {
        font-size: 24px;
        font-weight: bold;
        text-decoration: underline;
      }
    </style>
</head>
<body>
	<div class="container">		
		<div class="logo">
        <img src="cid:logo_thelandlord" alt="The Landlord" />
		</div>
		<h1>Confirmez votre adresse email pour The Landlord</h1>
    <h2>${fullName ? `Bonjour ${fullName}` : ``}</h2>
		<p>Nous sommes ravis de vous accueillir sur The Landlord. Avant de commencer, nous devons confirmer votre adresse email</p>
    ${
      isMobile
        ? `<p>Collez simplement le code ci-dessous en l'application pour confirmer votre inscription :</p>
      <h3>${token}</h3>`
        : `<p>Cliquez simplement sur le lien ci-dessous pour confirmer votre inscription :</p>
      <a href="${process.env.LANDLORD_WEB}/verification?res=${token}"><button>Vérifier</button></a>`
    }
      <p> En confirmant votre email, vous pourrez profiter pleinement de nos services et rester informé des dernières nouveautés et offres exclusives.</p>
    <p> Si vous n'avez pas créé de compte sur The Landlord, veuillez ignorer cet email ou nous en informer.</p>
    <p> Nous sommes impatients de vous offrir la meilleure expérience possible.</p>
    <p> Raise Your Expectations, 
L'équipe de The Landlord</p>
	</div>
</body>
</html>
`;
const sendNotificationReservation = (
  date_from,
  date_to,
  propertyName,
  property_id,
  price,
  reservation_id,
  clientName,
  clientPhone,
  clientEmail
) => `
<!DOCTYPE html>
<html>
  <head>
    <title>Nouvelle Réservation sur The Landlord</title>
    <style>
      body {
        background-color: #f1f1f1;
        font-family: Arial, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }
      .container {
        max-width: 600px;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }

      h1 {
        font-size: 24px;
        margin-top: 0;
        /* text-align: center; */
        color: #2da680; /* Base Color */
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.5;
        /* text-align: center; */
        /* color: #2da680; Base Color */
      }
      .logo {
        text-align: center;
        margin-bottom: 20px;
      }
      .logo img {
        max-width: 200px;
        height: auto;
      }
      button {
        background-color: #2da680; /* Complementary Color */
        border: none;
        color: #fff;
        padding: 10px 50px;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        display: block;
        margin: 0 auto;
      }
      button:hover {
        background-color: #278eba; /* Accent Color */
      }
      .reservation-details {
        font-size: 16px;
        margin-bottom: 20px;
      }
      .house-link {
        color: #2da680;
        text-decoration: underline;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo">
        <img src="cid:logo_thelandlord" alt="The Landlord" />
      </div>
      <h1>Nouvelle Réservation sur The Landlord</h1>
      <p>Une nouvelle réservation a été effectuée :</p>
      <div class="reservation-details">
       
          ${clientName ? ` <p><strong>Client :</strong> ${clientName}</p>` : ""}
        <p><strong>Email :</strong> ${clientEmail}</p>
        ${clientPhone ? `<p><strong>Phone :</strong> ${clientPhone}</p>` : ""}
      
        <p><strong>Date de début :</strong> ${date_from}</p>
        <p><strong>Date de fin :</strong>  ${date_to}</p>
        <p>
          <strong>Nom de la maison :</strong>
          <a href="${
            process.env.LANDLORD_WEB
          }/#/property-details/${property_id}" class="house-link">${propertyName}</a>
        </p>
        <p><strong>Prix :</strong> ${price} DT</p>
        <p>
          <strong>ID de la réservation :</strong>
          
            ${reservation_id}
          
        </p>
      </div>
      <p>
        Veuillez prendre les mesures nécessaires pour préparer cette réservation
        et informer le client de tous les détails pertinents.
      </p>

      <p>Cordialement, L'équipe de The Landlord</p>
    </div>
  </body>
</html>

`;

const contratHtml = () => `
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
  <head>
    <title>The LandLord</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap CSS -->
    <link
      rel="stylesheet"
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
      integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z"
      crossorigin="anonymous"
    />
    <!-- Signature Pad CSS -->
    <link rel="stylesheet" href="../../public/css/signature-pad.css" />

    <style>
      /* Inline CSS styles */
      input[type="radio"],
      input[type="checkbox"] {
        margin: 4px -17px 0 !important;
        margin-top: 1px;
        line-height: normal;
      }

      h3,
      h4 {
        color: #30ba98 !important;
        font-family: "roboto_regular", Arial, sans-serif;
      }

      p {
        text-align: justify !important;
        line-height: 2.2 !important;
        font-family: "roboto_regular", Arial, sans-serif;
        font-size: 0.899em !important;
        color: #414856;
      }

      .sig {
        visibility: hidden !important;
      }

      .footext {
        text-align: center;
        display: flex !important;
        justify-content: center;
        align-items: center;
        flex-wrap: nowrap;
      }

      /* .kbw-signature {
        width: 400px;
        height: 150px;
      } */

      .footer {
        text-align: center;
        margin-top: 50px; /* Adjust the margin as needed for spacing */
        display: flex !important;
        flex-direction: column;
      }

      #success_tic .page-body {
        max-width: 300px;
        background-color: #ffffff;
        margin: 10% auto;
      }

      #success_tic .page-body .head {
        text-align: center;
      }

      #success_tic .close {
        opacity: 1;
        position: absolute;
        right: 0px;
        font-size: 30px;
        padding: 3px 15px;
        margin-bottom: 10px;
      }

      #success_tic .checkmark-circle {
        width: 150px;
        height: 150px;
        position: relative;
        display: inline-block;
        vertical-align: top;
      }

      .checkmark-circle .background {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        background: #1ab394;
        position: absolute;
      }

      #success_tic .checkmark-circle .checkmark {
        border-radius: 5px;
      }

      #success_tic .checkmark-circle .checkmark.draw:after {
        -webkit-animation-delay: 300ms;
        -moz-animation-delay: 300ms;
        animation-delay: 300ms;
        -webkit-animation-duration: 1s;
        -moz-animation-duration: 1s;
        animation-duration: 1s;
        -webkit-animation-timing-function: ease;
        -moz-animation-timing-function: ease;
        animation-timing-function: ease;
        -webkit-animation-name: checkmark;
        -moz-animation-name: checkmark;
        animation-name: checkmark;
        -webkit-transform: scaleX(-1) rotate(135deg);
        -moz-transform: scaleX(-1) rotate(135deg);
        -ms-transform: scaleX(-1) rotate(135deg);
        -o-transform: scaleX(-1) rotate(135deg);
        transform: scaleX(-1) rotate(135deg);
        -webkit-animation-fill-mode: forwards;
        -moz-animation-fill-mode: forwards;
        animation-fill-mode: forwards;
      }

      #success_tic .checkmark-circle .checkmark:after {
        opacity: 1;
        height: 75px;
        width: 37.5px;
        -webkit-transform-origin: left top;
        -moz-transform-origin: left top;
        -ms-transform-origin: left top;
        -o-transform-origin: left top;
        transform-origin: left top;
        border-right: 15px solid #fff;
        border-top: 15px solid #fff;
        border-radius: 2.5px !important;
        content: "";
        left: 35px;
        top: 80px;
        position: absolute;
      }

      @-webkit-keyframes checkmark {
        0% {
          height: 0;
          width: 0;
          opacity: 1;
        }
        20% {
          height: 0;
          width: 37.5px;
          opacity: 1;
        }
        40% {
          height: 75px;
          width: 37.5px;
          opacity: 1;
        }
        100% {
          height: 75px;
          width: 37.5px;
          opacity: 1;
        }
      }
      #loader {
        width: 3rem;
        height: 3rem;
      }
    </style>
  </head>

  <body>
    <br />
    <br />
    <div class="container mt-5">
      <img src="data:image/png;base64,${logoBase64}" width="30%" />
      <br />
      <br />
      <b
        ><h3 style="text-align: center">
          SHORT-TERM RENTAL AGREEMENT
          <hr /></h3
      ></b>
      <br />

      <b> <h4>I.DESIGNATION OF THE PARTIES</h4></b>
      <p style="text-align: justify !important; line-height: 2.2">
        This contract is concluded between the undersigned:
      </p>
      <p style="text-align: justify; line-height: 2.2">
        - Name and first name of the representative
        <b
          >:Company The Landlord, 1631526V, located at the Résidence du Lac, Rue
          du Lac Victoria, Bloc C bureau 34, 1053 Les Berges du Lac, whose
          activity is short-term rental</b
        >
      </p>

      <p class="mt-1" style="text-align: justify; line-height: 2.2">
        Name and first name of the tenant :
        <b> client.name</b>, passport number / Identity card number:
        <b>client.cin, client.pays </b>.
      </p>
      <b> <h4>II. OBJECT OF THE CONTRACT</h4></b>
      <p
        class="mt-1"
        style="text-align: justify !important; line-height: 2.2 !important"
      >
        The object of this contract is the rental of accommodation named:
        <strong>property.name</strong> . Located at :
        <strong>property.street</strong> It was agreed and stopped as follows :
        It has been agreed and decided as follows: The Lessor gives rent to the
        Tenant the premises asa short term accomodation
      </p>
      <b><h4>III. EFFECTIVE DATE AND DURATION OF THE CONTRACT</h4></b>
      <p
        class="mt-1"
        style="text-align: justify !important; line-height: 2.2 !important"
      >
        The duration of the contract and its effective date are thus defined :
        <br />
        <strong>A.</strong> The duration of the contract and its effective date
        are thus defined:<br />
        <strong>B.</strong> Duration of the contract: This rental is granted for
        a period of <b> dayDiff </b>days from
        <strong>reservation.dateFrom </strong>
        . to end on
        <b> reservation.dateTo</b>
        .The lease automatically ceases at the expiration of this term without
        it being necessary for the lessor to notify the termination. It cannot
        be extended without the prior agreement of the lessor or its
        representative.
      </p>
      <b>
        <h4>IV. RENT</h4>
      </b>
      <p>
        This contract is fixed for an amount of :
        <strong> ///TODO check price depending from currency </strong>
      </p>
      <b><h4>V.GENERAL CONDITIONS</h4></b>
      <p style="text-align: justify !important; line-height: 2.2 !important">
        This rental is made under the following charges and conditions that the
        Tenant undertakes to execute and fulfill, namely:
        <strong>1.</strong> Only occupy the premises as a dwelling, the exercise
        of any trade, profession or industry being formally prohibited. The
        Tenant recognizing that the premises covered by this contract are only
        rented as a temporary residence . <strong>2.</strong> Respect the
        accommodation capacity of the home as descripted on the website .
        <strong>3.</strong> Respect the destination of the home and not make any
        changes to the arrangement of furniture and places;
        <strong>4.</strong> It is forbidden to substitute for any person
        whatsoever, or to sublet, in whole or in part, even free of charge, the
        rented places, except with the written agreement of the lessor.
        <strong>5.</strong> Refrain from throwing in the washbasins, bathtubs,
        bidets, sinks objects likely to obstruct the pipes, failing which he
        will be liable for the costs incurred for the return to service of this
        equipment <strong>6.</strong>Make any complaints concerning the
        installations within 48 hours of entering the accommodation. Otherwise,
        it cannot be admitted. <strong>7. </strong>Notify the Lessor as soon as
        possible of any damage affecting the home, its furniture or its
        equipment. Repairs made necessary by negligence or poor maintenance
        during the rental will be the responsibility of the tenant.
        <strong>8.</strong>Authorize the Lessor, or any third party appointed by
        him for this purpose, to carry out, during the rental period, any
        repairs ordered by emergency. The Tenant may not claim any reduction in
        rent in the event that urgent repairs incumbent on the lessor appear
        during the rental <strong>9.</strong> Avoid any noise or behavior, of
        his own making, of his family or of his acquaintances, likely to disturb
        the neighbors. <strong>10.</strong>Respect, in the event of a rental in
        an apartment building, the condominium regulations.
        <strong>11.</strong> Renounce any recourse against the Lessor in the
        event of theft and depredation in the leased premises.
        <strong>12.</strong> Maintain the rented accommodation and return it in
        a good state of cleanliness and rental repairs at the end of the rental
        period. If items in the inventory are damaged, the Lessor may claim
        their replacement value. <strong> 13.</strong> Smoking is prohibited in
        the accommodation. Any smell of cigarettes in the accommodation will be
        penalized in an amount of 500DT withheld directly from the security
        deposit. <strong>14.</strong> Party or event are forbidden. If this
        condition is not respected, the reservation will be immediatly be
        cancelled and the total amount of the deposit as well as the rest of the
        reservation will not be reimbursed.
      </p>
      <b><h4>VI. GUARANTEES</h4></b>
      <p style="text-align: justify; line-height: 2.2 !important">
        To guarantee the performance of the tenant's obligations, a security
        deposit of an amount of : <strong>caution</strong>. A Cheklist detailing
        the condition of the villa will be signed by both parties upon check-in.
        During the check-out, the inventory and the inventory will be made on
        the basis of this document.
      </p>
      <b><h4>VII. Cancelation</h4></b>
      <p style="text-align: justify; line-height: 2.2 !important">
        Full refund for cancellations made within 48 hours of booking, if the
        check-in date is at least 14 days away. 50% refund for cancellations
        made at least 7 days before check-in. No refunds for cancellations made
        within 7 days of check-in. <br />
        In case of force majeure, no refund will be made. The client will have a
        credit of the full amount paid, that could be spent within 12 months
        from the check-in day in the contract. The credit can only be used for
        the property described in this contract.
      </p>
      <div class="row mt-5" style="width: 100%">
        <div class="col">
          <h3 class="tag-ingo">Signature and stamp of the representative</h3>
          <img src="data:image/png;base64,${logoBase64Sig}" />
        </div>
        <div class="col" id="changethis">
          <div class="panel panel-default" style="width: 350px">
            <div class="panel-body center-text">
              <div id="signArea" class="mb-3">
                <h3 class="tag-ingo">Tenant Signature</h3>
                <div class="" style="height: auto">
                  <div id="signature-pad" class="signature-pad">
                    <div class="signature-pad--body" id="signatureContainer">
                      <canvas style="height: 200px"></canvas>
                    </div>
                  </div>
                </div>
              </div>
              <div class="form-group form-check">
                <label class="form-check-label">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    name="remember"
                    required
                  />
                  Read and approved
                  <div class="valid-feedback">Approved</div>
                  <div class="invalid-feedback">
                    Please check the following box.
                  </div>
                </label>
              </div>
              <div class="d-flex align-items-center">
                <button id="clear" class="btn btn-warning mr-2">Clear</button>
                <button id="save" type="submit" class="btn btn-success">
                  Save Signature
                </button>
            <span
              id="loader"
              class="ml-2 spinner-border spinner-border-sm"
              role="status"
              aria-hidden="true"
              style="display: none;"
            ></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <footer>
      <div class="footer">
        <p class="footext">The Landlord</p>
        <p class="footext">Code T.V.A: 1631526MA000</p>
        <p class="footext">contact@thelandlord.tn</p>
        <p class="footext">+216 58 59 59 00</p>
      </div>
    </footer>
  </body>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <link
    rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  />
  <link
    rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"
  />
  <script
    src="https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs"
    type="module"
  ></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
  <script src="../../public/javascripts/signature-touch.js"></script>
  <script src="../../public/javascripts/signature_pad.js"></script>
  <script>
    $(document).ready(function () {
      console.log("Document ready"); // Add this line for debugging

      // Initialize Signature Pad
      var canvas = document.querySelector("canvas");
      var signaturePad = new SignaturePad(canvas);

      // Clear signature
      $("#clear").click(function () {
        signaturePad.clear();
      });

      // Save signature
      $("#save").click(function () {
        // Check if "Read and approved" checkbox is checked
        if ($("input[name='remember']").is(":checked")) {
          if (!signaturePad.isEmpty()) {
            // Convert signature to PNG data URL
            var dataURL = signaturePad.toDataURL();
            // Disable the "Save Signature" button
            $("#save").prop("disabled", true);
            $("#clear").prop("disabled", false);
            $("#loader").show();
            $.ajax({
              type: "POST",
              url: "/api/user/create-contract",
              data: {
                signatureDataURL: dataURL,
              },
              success: function (response) {
                // Handle success response from the server
                console.log("Signature saved successfully:", response);
                if (response.success) {
                  // Replace the signature pad with the saved image
                  var signatureImage = new Image();
                  signatureImage.src = dataURL;
                  $("#signArea").replaceWith(signatureImage);

                  // Disable the "Save Signature" button
                  $("#loader").hide();
                  $("#save").prop("disabled", true);
                  $("#clear").prop("disabled", false);
                  // Show success message
                  alert("PDF created and saved successfully");
                } else {
                  $("#clear").prop("disabled", false);
                  $("#save").prop("disabled", false);
                  $("#loader").hide();
                  // Show error message
                  alert("Failed to create PDF. Please try again later.");
                }
              },
              error: function (xhr, status, error) {
                // Handle error response from the server
                console.error("Error saving signature:", error);
                $("#loader").hide();
                $("#clear").prop("disabled", false);
                $("#save").prop("disabled", false);
                alert("Failed to create PDF. Please try again later.");
              },
            });
          } else {
            alert("Please provide a signature first.");
          }
        } else {
          alert("Please read and approve before saving.");
        }
      });
    });
  </script>
</html>

`;
const contactUsMail = (email, name, subject, body, phone) => `
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact Us - The Landlord</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f1f1f1;
        margin: 0;
        padding: 0;
      }
      .container {
        max-width: 600px;
        margin: 20px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }
      .header {
        background-color: #2da680;
        color: #fff;
        padding: 10px 20px;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
      }
      h1 {
        font-size: 24px;
      }
      p {
        font-size: 16px;
        line-height: 1.5;
      }
      .footer {
        text-align: center;
        margin-top: 20px;
      }
      .footer p {
        font-size: 14px;
        color: #888;
      }
      .logo img {
        max-width: 150px;
        height: auto;
        display: block;
        margin: 0 auto;
      }
      .button {
        background-color: #2da680;
        color: #fff;
        text-decoration: none;
        padding: 10px 20px;
        border-radius: 5px;
        display: inline-block;
        margin-top: 20px;
      }
      .button:hover {
        background-color: #278eba;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <img src="cid:logo_thelandlord" alt="The Landlord Logo" class="logo" />
      </div>
      <div class="content">
        <h1>New Contact Us Form Submission</h1>
        <p>Dear Team,</p>
        <p>
          A new message has been received from the contact us form on the
          website. Here are the details:
        </p>
        <ul>
          <li><strong>Name:</strong> ${name}</li>
          <li><strong>Email:</strong> ${email}</li>
          <li><strong>Phone:</strong> ${phone}</li>
          <li><strong>Subject:</strong> ${subject}</li>
          <li>
            <strong>Message:</strong> ${body}
          </li>
        </ul>
        <p>Please respond to this inquiry as soon as possible.</p>
      </div>
      <div class="footer">
        <p>Thank you,<br />The Landlord Team</p>
      </div>
    </div>
  </body>
</html>

`;

// export module
module.exports = {
  sendConfirmationMail,
  forgotPasswordEmailTemplate,
  resetPasswordConfirmationEmailTemplate,
  contratHtml,
  contractMail,
  emailReservationForCheckin,
  sendNotificationReservation,
  contactUsMail,
  notificationMessage,
  newPartnerMail,
};
