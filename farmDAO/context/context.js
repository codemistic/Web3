//Import Dependencies and hooks needed for app
import { createContext, useEffect } from "react";
import {
  useVote,
  useToken,
  useAddress,
  useMetamask,
  useDisconnect,
} from "@thirdweb-dev/react";
import { VoteType } from "@thirdweb-dev/sdk";
import { ethers } from "ethers";

export const FarmDAOContext = createContext();
export const FarmDAOProvider = ({ children }) => {
  /*
    Step 1. Get User address using thirdwebs hook
    Step 2. Get Token and vote contract instances using thirdwebs hooks
    Step 3. We need way to connect and disconnect from the dapp. 
  */
  const currentUserAddress = useAddress(); //Get the address using
  let vote = useVote("0xd8a0c13aF520E8Fa20de7f9459763aD84D9358d8");
  let token = useToken("0x892ce8705658BEc10CfF76Ee087E234A332B3664");
  let connectWithMetamask = useMetamask();
  let disconnectWallet = useDisconnect();

  useEffect(() => {
    (async () => {
      try {
        const delegatation = await token.getDelegation(currentUserAddress);
        if (delegatation === ethers.constants.AddressZero) {
          await token.delegateTo(currentUserAddress);
        }
      } catch (e) {
        console.log(e);
      }
    })();
  }, []);

  //Get all the proposals in the contract
  const getAllProposals = async () => {
    const proposals = await vote.getAll();
    return proposals;
    // console.log(proposals);
  };

  //Check if proposal given is executable
  const isExecutable = async (id) => {
    const canExecute = await vote.canExecute(id);
    return canExecute;
  };

  //Check if the user has voted for the given proposal
  const checkIfVoted = async (id) => {
    const res = await vote.hasVoted(id, currentUserAddress);
    console.log(res, "hasVoted");
  };

  //Create  proposal to mint tokens to the DAO's treasury
  const createProposal = async (description) => {
    const proposal = await vote.propose(description);
    console.log(proposal);
  };

  //Execute proposal if the proposal is successful
  const executeProposal = async (id) => {};

  //Vote for the proposal and delegate tokens if not already done.
  const voteFor = async (id, type, reason) => {
    try {
      const delegation = await token.getDelegationOf(currentUserAddress);
      if (delegation === ethers.constants.AddressZero) {
        await token.delegateTo(currentUserAddress);
      }
      let voteType;
      if (type === "Against") {
        voteType = VoteType.Against;
      } else if (type === "For") {
        voteType = VoteType.For;
      } else {
        voteType = VoteType.Abstain;
      }
      const res = await checkIfVoted(id);
      if (!res) {
        await vote.vote(id, voteType, reason);
      } else {
        console.log("You have already voted for this proposal");
      }
    } catch (error) {
      console.log(error);
    }
  };
  return (
    <FarmDAOContext.Provider
      value={{
        getAllProposals,
        isExecutable,
        voteFor,
        createProposal,
        currentUserAddress,
        connectWithMetamask,
        disconnectWallet,
        executeProposal,
      }}
    >
      {children}
    </FarmDAOContext.Provider>
  );
};
