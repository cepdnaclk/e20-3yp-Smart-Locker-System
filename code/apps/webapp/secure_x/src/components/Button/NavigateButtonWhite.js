import { useNavigate } from "react-router-dom";
import './NavigateButtonWhite.css'

const NavigateButtonWhite = ({ to, text }) => {
  const navigate = useNavigate();

  return (
    <button 
      className="NavigationBtnW"
      onClick={() => navigate(to)}
    >
      {text}
    </button>
  );
};

export default NavigateButtonWhite;
