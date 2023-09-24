let Hooks = {}

Hooks.Komen = {
    mounted() {
        this.el.addEventListener("submit", (e) => {
            e.preventDefault();
            let selectID = e.target.getAttribute("sid");
            let zone = e.target.getAttribute("zone");
            let komen = e.target.querySelector(`input[name='comment']`).value;

            let date = new Date();
            let hours = date.getHours();
            let minutes = date.getMinutes();

            this.pushEvent("komen", {comment: komen, id: selectID, zone: zone, time: `${hours}:${minutes}`});
            e.target.querySelector(`input[name='comment']`).value = "";
        })
    }
}

Hooks.Drag = {
    mounted() {
        const hook = this;
        const selector = "#" + this.el.id;

        document.querySelectorAll(".dropzone").forEach(item => {
            new Sortable(item, {

                animation: 0,
        
                delay: 50,
        
                delayOnTouchOnly: true,
        
                group: 'shared',
        
                draggable: '.draggable',
        
                // ghostClass: 'sortable-ghost'
                onEnd: function(evt) {
                    hook.pushEventTo(selector, "dropped", {
                        dragId: evt.item.id, // id dari item yang kita sedang drag,
                        dropzoneId: evt.to.id, // id tempat kita menaruh item yang kita drag
                        draggableIndex: evt.newDraggableIndex // index dimana item nya di drop
                    })
                },
        
              });
        
        });
    }
}

export default Hooks;