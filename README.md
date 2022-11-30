# docker-sui

### Run the [sui](https://docs.sui.io/devnet/build/install) Docker container:

```console
docker run -it georgedigkas/sui /bin/bash
```

### Generate the config file for the sui-client
```console
sui client
```
## Clone an existing move dApp from GitHub
### Clone the source code of an existing move dApp
```console
cd /home/
git clone https://github.com/amnn/nftrpg
cd nftrpg
```

### (Optional Step - specifically for this project) - Replace `01989d3d5` with `devnet` in order to be able to build the project
```console
sed -i 's/01989d3d5/devnet/g' Move.toml
```

### Build the project
```console
sui move build
```

### Prerequirement our newly generated wallet to have enough funds. If it does not have ask from the [Discord faucet](https://discord.gg/Sui). Get the address of the newly generated wallet
```console
sui client active-address
```

### Publish the dApp
```console
sui client publish --gas-budget 10000
```

## Mount into the container the source code of a local dApp (i.e. `nftrpg`), build it inside the container and publish it
NOTE: the binding of the volumes/directories is bidirectional the changes that are performed inside the container are stored also in the host machine and vice versa
```console
docker run -it -v "$(pwd)"/nftrpg:/home/nftrpg georgedigkas/sui /bin/bash
```

### Generate the config file for the sui-client
```console
sui client
```

### cd into mounted dApp
```console
cd /home/nftrpg
```

### (Optional Step - specifically for this project) - Replace `01989d3d5` with `devnet` in order to be able to build the project
```console
sed -i 's/01989d3d5/devnet/g' Move.toml
```

### Build the project
```console
sui move build
```

### Prerequirement our newly generated wallet to have enough funds. If it does not have ask from the [Discord faucet](https://discord.gg/Sui). Get the address of the newly generated wallet
```console
sui client active-address
```

### Publish the dApp
```console
sui client publish --gas-budget 10000
```
