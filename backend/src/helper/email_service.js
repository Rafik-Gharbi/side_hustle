const nodemailer = require("nodemailer");
const path = require("path");

function sendMail(email, subject, template, host, pdf) {
  let secure = host == "localhost" || host == "192.168.100.47";
  var mailData = {
    from: process.env.AUTH_USER_EMAIL,
    to: email,
    subject: subject,
    html: template,
    attachments: [
      {
        filename: "logo_thelandlord.png",
        path: path.join(__dirname, "../../public/images/logo_thelandlord.png"),
        cid: "logo_thelandlord",
      },
      pdf && {
        filename: "contract.pdf",
        path: pdf,
      },
    ].filter(Boolean),
  };

  return new Promise((resolve, reject) => {
    nodemailer
      .createTransport({
        host: process.env.HOST_MAIL,
        port: process.env.MAIL_PORT,
        secure: false,
        debug: true,
        // logger: true,
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
