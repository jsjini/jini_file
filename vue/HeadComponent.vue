<template>
  <div id="myDIV" class="header">
    <h2 style="margin:5px">My To Do List</h2>
    <input type="text" v-model="myInput" placeholder="Title...">
    <span v-on:click="newElement()" class="addBtn">Add</span>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        myInput: ''
      }
    },
    methods: {
      newElement() {
        this.$emit('add-todo', this.myInput);
        this.myInput = '';
      }
    }
  }
</script>