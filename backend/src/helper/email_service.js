const nodemailer = require("nodemailer");
const path = require("path");

async function sendMail(email, subject, template, host, pdf) {
  var mailData = {
    from: process.env.AUTH_USER_EMAIL,
    to: email,
    subject: subject,
    html: template,
  };

  return await new Promise((resolve, reject) => {
    nodemailer
      .createTransport({
        host: process.env.HOST_MAIL,
        port: parseInt(process.env.MAIL_PORT),
        secure: true,
        debug: true,
        logger: false,
        tls: {
          ciphers: "SSLv3",
          rejectUnauthorized: false,
        },
        auth: {
          user: process.env.AUTH_USER_EMAIL,
          pass: process.env.AUTH_USER_PASSWORD,
        },
      })
      .sendMail(mailData, (error, info) => {
        if (error) {
          console.log(`Error sending mail`);
          console.error("\x1b[31m%s\x1b[0m", error);
        } else {
          resolve(info);
        }
      });
  });
}
module.exports = { sendMail };
