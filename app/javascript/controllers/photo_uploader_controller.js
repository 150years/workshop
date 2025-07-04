import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  resizeAndUpload(event) {
    Array.from(event.target.files).forEach(file => {
      const img = document.createElement("img");
      const canvas = document.createElement("canvas");
      const reader = new FileReader();

      reader.onload = e => {
        img.src = e.target.result;
        img.onload = () => {
          const scale = 640 / Math.max(img.width, img.height);
          canvas.width = img.width * scale;
          canvas.height = img.height * scale;
          const ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
          canvas.toBlob(blob => {
            const dt = new DataTransfer();
            dt.items.add(new File([blob], file.name, { type: file.type }));
            event.target.files = dt.files;
            event.target.form.requestSubmit();
            event.target.value = null;
          }, file.type, 0.9);
        }
      };
      reader.readAsDataURL(file);
    });
  }
}
