import React, { useContext } from "react";
import styles from "../styles/Login.module.css";
import { FarmDAOContext } from "../context/context";
import Image from "next/image";
import FarmDAO from "../assets/FarmDAO.png";

const Login = () => {
  const { connectWithMetamask } = useContext(FarmDAOContext);
  return (
    <div className={styles.wrapper}>
      <div className={styles.title}>
        <Image className="logo" src={FarmDAO} alt="" />
      </div>
      <button className={styles.button} onClick={connectWithMetamask}>
        Connect with Metamask
      </button>
    </div>
  );
};

export default Login;
