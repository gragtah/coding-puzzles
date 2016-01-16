'use strict';
/** @flow */

const run = (lines) => {
  const inp = lines.map(l => l.split(' ').map(n => parseInt(n, 10)));
  const fst = inp.shift();
  const n = fst[0];
  const m = fst[1];

  const edges = {};
  const indeg = {};

  for (let i = 1; i <= n; i += 1) {
    edges[i] = [];
    indeg[i] = 0;
  }

  for (let i = 0; i < m; i += 1) {
    let e = inp.shift();
    const ui = e[0];
    const vi = e[1];
    if (ui >= vi) {
      edges[vi].push(ui);
      indeg[ui] += 1;
    } else {
      edges[ui].push(vi);
      indeg[vi] += 1;
    }
  }

  const entries = Object.keys(indeg).filter(i => indeg[i] === 0);

  if (entries.length !== 1) {
    throw new Error("Illegal tree structure. Either graph or forest.")
  }

  const depths = calcDepths(entries[0], edges);

  console.log(edges);
  console.log(depths);
};

const calcDepths = (start, edges) => {
  const depths = {};
  Object.keys(edges).forEach(e => { depths[e] = 1; });

  const go = s => {
    edges[s].forEach(go);
    depths[s] = edges[s].reduce((b, a) => b + depths[a], 1);
  };

  go(start);
  return depths;
};

const main = () => {
  process.stdin.resume();
  process.stdin.setEncoding("ascii");
  let _input = "";
  process.stdin.on("data", function (input) {
    _input += input;
  });

  process.stdin.on("end", function () {
    run(_input.split('\n'));
  });
};

main();
