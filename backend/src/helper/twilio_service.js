// const twilio = require("twilio");
// const client = twilio(
//   process.env.TWILIO_ACCOUNT_SID,
//   process.env.TWILIO_AUTH_TOKEN
// );

// const sendOTP = async (phoneNumber) => {
//   try {
//     const verification = await client.verify.v2
//       .services(process.env.TWILIO_SERVICE_SID)
//       .verifications.create({ to: `${phoneNumber}`, channel: "sms" });

//     console.log(verification.status); // Output: pending

//     return verification;
//   } catch (error) {
//     console.error(error);
//     throw new Error("otp_send_failed");
//   }
// };

// const verifyOTP = async (phoneNumber, code) => {
//   try {
//     const verificationCheck = await client.verify.v2
//       .services(process.env.TWILIO_SERVICE_SID)
//       .verificationChecks.create({ to: `${phoneNumber}`, code });

//     console.log(verificationCheck.status); // Output: approved or pending

//     return verificationCheck.status;
//   } catch (error) {
//     console.error(error);
//     throw new Error("otp_verif_failed");
//   }
// };

// module.exports = { sendOTP, verifyOTP };
