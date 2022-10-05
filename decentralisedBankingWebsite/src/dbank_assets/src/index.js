import { dbank } from "../../declarations/dbank"

window.addEventListener("load",async function(){
  update();
})

document.querySelector("form").addEventListener("submit", async function(event){
  event.preventDefault();
  const button=event.target.querySelector("#submit-btn");
  const inputAmount=parseFloat(document.getElementById("input-amount").value);
  const withdrawAmount=parseFloat(document.getElementById("withdrawal-amount").value);

  button.setAttribute("disabled",true);
  if(document.getElementById("input-amount").value.length !=0 ){
    await dbank.topUp(inputAmount);
  }
  if(document.getElementById("withdrawal-amount").value.length !=0 ){
    await dbank.withdraw(withdrawAmount);
  }
  // await dbank.withdraw(withdrawAmount);
  await dbank.compound();
  update();
  document.getElementById("input-amount").value="";
  document.getElementById("withdrawal-amount").value="";
  button.removeAttribute("disabled");
})

async function update(){
  const currAmount=await dbank.checkBalance();
  document.getElementById("value").innerHTML=Math.round(currAmount*100)/100;
}