import React, {Component} from 'react';
import {Card, Button} from 'semantic-ui-react';
import factory from "../ethereum/factory";
import 'semantic-ui-css/semantic.min.css';
import Layout from "../components/Layout";
import {Link} from "../routes";
import web3 from "../ethereum/web3";

class CampaignIndex extends Component {
  static async getInitialProps(){
    const kaizens=await factory.methods.getDeployedKaizens().call();
    const approvers=await factory.methods.getApprovers().call();
    return {kaizens,approvers};
  }

renderCampaigns(){
  const items=this.props.kaizens.map(address=>{
    return{
      header:address,
      description:(
        <Link route={`/campaigns/${address}`}>
        <a>View Kaizen Proposal</a>
        </Link>
      ),
      fluid:true
    };
  });

  return <Card.Group items={items} />;
}


renderApprovers(){
  const items1=this.props.approvers.map(address=>{
    return{
      header:address,
      fluid:true
    };
  });

  return <Card.Group items={items1} />;
}


render(){

    return (
      <Layout>


      <Button.Group horizontal>
      <Link route="/campaigns/new">
      <a>
      <Button
        floated="right"
        content="Create Kaizen"
        icon="add circle"
        primary={true}
      />
      </a>

      </Link>
      <Link route="/campaigns/approver">
      <a>
      <Button
      color="green"
        floated="right"
        content="Add Approver"
        icon="add circle"
        primary={true}
      />
      </a>
      </Link>

      <Link route="/campaigns/approver_delete">
      <a>
      <Button
        color="red"
        floated="right"
        content="Remove Approver"
        icon="minus circle"
        primary={true}
      />
      </a>
      </Link>

      <Link route="/campaigns/approverList">
      <a>
      <Button
        color="red"
        floated="right"
        content="List Approvers"
        primary={true}
      />
      </a>
      </Link>

      

</Button.Group>
<div></div>
<h3>Open Kaizens</h3>
<div></div>
{this.renderCampaigns()}

      </Layout>
    );

  }
}

export default CampaignIndex;
