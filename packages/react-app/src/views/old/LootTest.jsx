import { Button, Card, DatePicker, Divider, Input, List, Progress, Slider, Spin, Switch, Row, Col } from "antd";
import React, { useEffect, useState } from "react";
import { ReactComponent as CardEx } from "../card_ex.svg";
import * as svgUtils from "../../helpers/svgUtils";

export default function LootTest({
  address,
  mainnetProvider,
  localProvider,
  yourLocalBalance,
  price,
  tx,
  readContracts,
  writeContracts,
}) {
  const [imgSrc, setImgSrc] = useState(null);
  const [tokenIdx, setTokenIdx] = useState(0);
  const init = async () => { };

  const update = async () => { };
  useEffect(() => {
    if (readContracts && readContracts.Gears) {
      init();
    }
  }, [readContracts]);

  function getRandomInt(max) {
    return Math.floor(Math.random() * max);
  }
  const mintLoot = async () => {
    const token_idx = getRandomInt(1000);
    const rarityLevel = getRandomInt(4);
    const result = await readContracts.Gears.randomTokenURI(token_idx, rarityLevel);
    setTokenIdx(token_idx);

    const base64_data = result.split("base64,")[1];
    const decoded_str = svgUtils.atob(base64_data);
    const decoded_json = JSON.parse(decoded_str);
    console.log(decoded_json);
    const svg_img = decoded_json.image;
    setImgSrc(svg_img);
  };

  return (
    <div style={{ maxWidth: 1024, margin: "auto", paddingBottom: 56 }}>
      <Button onClick={mintLoot} style={{ marginBottom: "5px", marginTop: "25px" }}>
        Show Random Loot Item Card
      </Button>
      <Divider />

      <img src={imgSrc}></img>
    </div>
  );
}