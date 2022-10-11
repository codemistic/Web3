import { useContext, useEffect, useState } from "react";
import { FarmDAOContext } from "../context/context";
import { ethers } from "ethers";
import styles from "../styles/Home.module.css";
import Login from "../components/Login";
import Header from "../components/Header";
import ProposalCard from "../components/ProposalCard";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/ReactToastify.min.css";

const Home = () => {
  const [proposals, setProposals] = useState(null);
  const [proposalInput, setProposalInput] = useState("");
  const { getAllProposals, isExecutable, currentUserAddress, createProposal } =
    useContext(FarmDAOContext);

  useEffect(() => {
    getAllProposals()
      .then((proposals) => {
        if (proposals.length > 0) {
          setProposals(proposals.reverse());
          console.log(proposals);
          isExecutable(proposals[0].proposalId);
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);
  return (
    <div className={styles.wrapper}>
      {currentUserAddress ? (
        <>
          <Header />
          <ToastContainer />

          {/* {address === '0x35d94e754F4c368F1A64B998751cd4d597Ae8fE6' && (
            <>
              <h3>Need More Tokens</h3>
              <button onClick={mintTokens}>mint</button>
            </>
          )} */}
          <div className={styles.content}>
            <div className={styles.createProposalForm}>
              <div className={styles.formTitle}>Make a Proposal</div>
              <input
                className={styles.formInput}
                placeholder="Make a Proposal"
                value={proposalInput}
                onChange={(e) => {
                  setProposalInput(e.target.value);
                }}
              />
              <button
                className={styles.formButton}
                disabled={!proposalInput}
                onClick={() => {
                  createProposal(proposalInput);
                  setProposalInput("");
                  toast.info("⏳ Submitting Proposal ⏳", {
                    position: "top-center",
                    autoClose: 8000,
                    hideProgressBar: false,
                    closeOnClick: true,
                    pauseOnHover: true,
                    draggable: true,
                    progress: undefined,
                    theme: "dark",
                  });
                }}
              >
                Submit
              </button>
            </div>

            <div className={styles.proposals}>
              {proposals &&
                proposals.map((proposal) => {
                  return (
                    <ProposalCard key={Math.random()} proposal={proposal} />
                  );
                })}
            </div>
          </div>
        </>
      ) : (
        <Login />
      )}
    </div>
  );
};

export default Home;
