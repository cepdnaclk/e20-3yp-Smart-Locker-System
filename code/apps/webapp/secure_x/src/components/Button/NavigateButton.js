import { useNavigate } from "react-router-dom";
import './NavigateButton.css'

const NavigateButton = ({ to, text }) => {
  const navigate = useNavigate();

  return (
    <button 
      className="NavigationBtn"
      onClick={() => navigate(to)}
    >
      {text}
    </button>
  );
};

export default NavigateButton;
