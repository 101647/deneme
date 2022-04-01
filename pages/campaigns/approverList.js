import React, {Component} from 'react';
import Layout from "../../components/Layout";
import {Form,Button,Input,Message,Card} from "semantic-ui-react";
import factory from "../../ethereum/factory";
import web3 from "../../ethereum/web3";
import {Router} from "../../routes";



class ApproverList extends Component{

  static async getInitialProps(){

    const approvers=await factory.methods.getApprovers().call();
    return {approvers};
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



  <h3>List of Approvers</h3>
  <div></div>
  {this.renderApprovers()}
      </Layout>
    );

  }
  }





export default ApproverList;
