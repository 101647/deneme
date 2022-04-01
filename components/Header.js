import React from 'react';
import {Menu} from 'semantic-ui-react';
import {Link} from '../routes';

export default () => {
  return(
    <Menu style={{ marginTop:'10px'}}>

    <Link route="/">
      <a className="item">KEAS KAIZEN</a>
    </Link>



      <Menu.Menu position="right">
      <Link route="/">
        <a className="item">Kaizens</a>
      </Link>
      <Link route="/campaigns/new">
        <a className="item">Create Kaizen</a>
      </Link>
      </Menu.Menu>
    </Menu>
  );
};
