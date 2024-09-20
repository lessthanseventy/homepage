// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import {
  SearchControl,
  OpenStreetMapProvider,
} from "../vendor/leaflet-geosearch";

let Hooks = {};
Hooks.UploadHook = {
  mounted() {
    this.el.addEventListener("change", (event) => {
      let file = event.target.files[0];
      console.log(file);
      if (file && file.type === "text/xml") {
        let reader = new FileReader();
        reader.onload = (event) => {
          let content = event.target.result;
          this.pushEvent("validate", {
            xml_file: { name: file.name, content: content },
          });
        };
        reader.readAsText(file);
      } else {
        this.pushEvent("validate", {});
      }
    });
  },
};
Hooks.MapComponent = {
  mounted() {
    this.initializeMap();
    this.handleEvent("centerMapOnFirstFoodTruck", (foodTrucks) => {
      if (foodTrucks.filtered_food_trucks.length > 0) {
        let firstFoodTruck = foodTrucks.filtered_food_trucks[0];
        this.map.setView([firstFoodTruck.lat, firstFoodTruck.lon], 14);
      }
    });
  },
  updated() {
    this.initializeMap();
  },
  initializeMap() {
    // If a map already exists, remove it
    if (this.map) {
      this.map.remove();
    }

    // Initialize a new map
    this.map = L.map(this.el).setView([37.7749, -122.4194], 14); // Coordinates for San Francisco
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
    }).addTo(this.map);

    const provider = new OpenStreetMapProvider({
      params: {
        viewbox: "-123.173825,37.63983,-122.3265,37.929824", // The bounding box for San Francisco
        bounded: 1,
      },
    });
    const searchControl = new SearchControl({
      provider: provider,
      style: "search",
      showResult: (result, value) => {
        // Override the showResult method
        this.map.panTo(result.center); // Pan to the location without adding a marker
      },
    });

    this.map.addControl(searchControl);

    // Add event listener to map click event
    this.map.on("click", function (e) {
      // Find the search bar element
      let searchBar = document.querySelector(".leaflet-control-geosearch");
      // Check if the search bar is expanded
      if (searchBar.classList.contains("active")) {
        // If it is, simulate a click on the search bar to collapse it
        searchBar.classList.remove("active");
      }
    });

    // Get the food trucks from the dataset attribute
    let foodTrucks = JSON.parse(this.el.dataset.foodTrucks);
    let activeFoodTruckId = this.el.dataset.selectedFoodTruck;

    // Add a marker for each food truck
    for (let i = 0; i < foodTrucks.length; i++) {
      let foodTruck = foodTrucks[i];
      let marker = L.marker([foodTruck.lat, foodTruck.lon]).addTo(this.map)
        .bindPopup(`
        <div class="flex flex-col gap-2 justify-left px-5 w-full">
          <div class="font-bold">
            ${foodTruck.name}
          </div>
          <div class="flex w-full"><div class="w-1/3 mr-5">Type:</div><div class="w-2/3">${foodTruck.type}</div></div>
          <div class="flex w-full"><div class="w-1/3 mr-5">Address:</div><div class="w-2/3">${foodTruck.address}</div></div>
          <div class="flex w-full"><div class="w-1/3 mr-5">Location:</div><div class="w-2/3">${foodTruck.location_description}</div></div>
          <div class="flex w-full"><div class="w-1/3 mr-5">Description:</div><div class="w-2/3">${foodTruck.food_items.join(", ")}</div></div>
          <div class="flex w-full"><div class="w-1/3 mr-5">Schedule:</div><a class="w-2/3" href="${foodTruck.schedule}" target="_blank">Schedule</a></div>
        </div>
        `); // Add a popup to each marker
      // If this is the active food truck, highlight the marker
      if (foodTruck.id == activeFoodTruckId) {
        console.log("got here");
        this.map.whenReady(function () {
          marker.openPopup();
        });
      }
      marker.on("click", function () {
        // Update the URL with the active food truck ID
        let url = new URL(window.location.href);
        url.searchParams.set("selected_food_truck", foodTruck.id);
        history.pushState({}, "", url);
      });
    }
    this.map.on("popupclose", function () {
      // Clear the active food truck ID from the URL
      let url = new URL(window.location.href);
      url.searchParams.delete("selected_food_truck");
      history.replaceState({}, "", url);
    });
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

liveSocket.on("display-map", ({ detail: { food_trucks } }) => {
  initMap(food_trucks);
});

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
