import motoko_token from 'ic:canisters/motoken';

motoko_token.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
