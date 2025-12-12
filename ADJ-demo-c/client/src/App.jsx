import TestController from "./modules/test/test.controller";
function App() {
  return (
    <>
      <nav className="navbar navbar-expand-lg bg-body-tertiary">
        <div className="container-fluid">
          <a href="" className="navbar-brand">
            ADJ-Demo-c
          </a>
          <div className="collapse navbar-collapse">
            <ul className="navbar-nav">
              <li className="nav-item">
                <a href="" className="nav-link active">
                  Home
                </a>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <div className="container m-5">
        <h2>Inicio</h2>
        <hr />
        <button
          onClick={() => TestController.callToApi()}
          className="btn btn-success"
        >
          Llamar a mi API
        </button>
      </div>
    </>
  );
}

export default App;
