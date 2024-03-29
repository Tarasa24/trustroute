import consumer from "./consumer";

export function connect(identifier) {
  consumer.subscriptions.create(
    {
      channel: "AsyncRedirectChannel",
      identifier: identifier,
    },
    {
      received(data) {
        const path = data.path;
        const flash = data.flash;

        document.addEventListener("turbo:render", () => {
          if (flash) {
            const flashElement = document.getElementById("flash");
            flashElement.innerHTML = flash;
          }
        });
        Turbo.visit(path);
      }
    }
  );
}