
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JubilARDAO {
    struct Propuesta {
        string descripcion;
        uint votosAFavor;
        uint votosEnContra;
        bool ejecutada;
    }

    address public owner;
    mapping(address => bool) public miembros;
    Propuesta[] public propuestas;

    modifier soloMiembro() {
        require(miembros[msg.sender], "No sos miembro");
        _;
    }

    constructor() {
        owner = msg.sender;
        miembros[msg.sender] = true;
    }

    function agregarMiembro(address nuevoMiembro) public {
        require(msg.sender == owner, "Solo el owner puede agregar");
        miembros[nuevoMiembro] = true;
    }

    function crearPropuesta(string memory descripcion) public soloMiembro {
        propuestas.push(Propuesta(descripcion, 0, 0, false));
    }

    function votar(uint idPropuesta, bool aFavor) public soloMiembro {
        require(!propuestas[idPropuesta].ejecutada, "Ya ejecutada");
        if (aFavor) {
            propuestas[idPropuesta].votosAFavor++;
        } else {
            propuestas[idPropuesta].votosEnContra++;
        }
    }

    function ejecutarPropuesta(uint idPropuesta) public soloMiembro {
        Propuesta storage p = propuestas[idPropuesta];
        require(!p.ejecutada, "Ya ejecutada");
        require(p.votosAFavor > p.votosEnContra, "No aprobada");
        p.ejecutada = true;
        // Aquí se puede vincular con subsidios, pagos, etc.
    }

    function verPropuesta(uint id) public view returns (string memory, uint, uint, bool) {
        Propuesta memory p = propuestas[id];
        return (p.descripcion, p.votosAFavor, p.votosEnContra, p.ejecutada);
    }
}
