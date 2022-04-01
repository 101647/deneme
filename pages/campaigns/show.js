import React, {Component} from "react";
import Layout from "../../components/Layout";
import KaizenContract from "../../ethereum/KaizenContract";
import {Card,Grid,Button} from "semantic-ui-react";
import web3 from "../../ethereum/web3";
//import ContributeForm from "../../components/ContributeForm";
import {Link,Router} from "../../routes";


class CampaignShow extends Component {
  static async getInitialProps(props){
    const campaign = KaizenContract(props.query.address);
    const summary=await campaign.methods.getSummary().call();
    return{
      address:props.query.address,
      description:summary[0],
      creator:summary[1],
      approvalCount:summary[2],
      approverCount:summary[3]
    };
  }

  onApprove = async ()=>{
    const campaign = KaizenContract(this.props.address);
    const accounts=await web3.eth.getAccounts();
    await campaign.methods.approveKaizen().send({
      from:accounts[0]
    });
    Router.pushRoute(`/campaigns/${this.props.address}`);
  };



renderCards(){
  const {
    description,
    creator,
    approvalCount,
    approverCount
  }=this.props;



  const items=[
    {
      header: description,
      meta: "Kaizen Description",
      description: "The description of the proposed Kaizen",
      style: {overflowWrap:'break-word'}
    },

    {
      header: creator,
      meta: "The owner of the Kaizen Proposal",
      description: "ETH address of the owner of the proposal",
      style: {overflowWrap:'break-word'}
    },

    {
      header: approvalCount,
      meta: "Total approvals",
      description: "Total number of approves of this Kaizen Proposal",
      style: {overflowWrap:'break-word'}
    },
    {
      header: approverCount,
      meta: "Total approvers",
      description: "Total number of approvers of this Kaizen Proposal",
      style: {overflowWrap:'break-word'}
    }

  ];
  return <Card.Group items={items} />;
}

  render(){
    return (
      <Layout>
      <h3>Kaizen Show</h3>
      <Grid>
      <Grid.Row>
      <Grid.Column width={10}>
      {this.renderCards()}

      </Grid.Column>
      <Grid.Column width={6}>

      </Grid.Column>
      </Grid.Row>
      <Grid.Row>
      <Grid.Column>

      <Button color="green" basic onClick={this.onApprove}>Approve
      </Button>
      
      </Grid.Column>
      </Grid.Row>
      </Grid>


      </Layout>
    );
  }
}

export default CampaignShow;
