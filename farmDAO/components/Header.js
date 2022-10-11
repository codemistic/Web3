import React, { useContext } from "react";
import styles from "../styles/Header.module.css";
import { FarmDAOContext } from "../context/context";
import Image from "next/image";
import FarmDAO from "../assets/FarmDAO.png";
import farmCoin from "../assets/farmdao1.png";

const Header = () => {
  const { disconnectWallet } = useContext(FarmDAOContext);
  return (
    <div className={styles.wrapper}>
      <Image className="logo" height={150} width={500} alt="" src={FarmDAO} />
      <div className={styles.coin}>
        <Image className="logo" height={65} width={65} alt="" src={farmCoin} />
        <p>
          <a
            target="_blank"
            href="https://thirdweb.com/mumbai/0x892ce8705658BEc10CfF76Ee087E234A332B3664/"
            rel="noreferrer"
          >
            FarmCoins:
          </a>
          {"  "}Gives you the Power to <strong>VOTE!</strong>
        </p>
      </div>
      <button className={styles.disconnectBtn} onClick={disconnectWallet}>
        Disconnect Wallet 👋
      </button>
    </div>
  );
};

export default Header;
