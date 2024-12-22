// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"

import IncomeForecastController from "./income_forecast_controller";
application.register("income-forecast", IncomeForecastController);
