import { BastionSMSPlugin } from 'bastion-sms';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    BastionSMSPlugin.echo({ value: inputValue })
}
