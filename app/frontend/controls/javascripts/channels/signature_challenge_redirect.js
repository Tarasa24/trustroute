import consumer from "./consumer";

export function connect(key_uuid) {
  consumer.subscriptions.create(
    {
      channel: "AsyncRedirectChannel",
      identifier: `signature_challenge:${key_uuid}`,
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