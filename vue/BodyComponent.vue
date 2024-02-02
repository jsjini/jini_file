<template>
  <ul id="myUL">
    <li v-for="todo in todos" v-bind:key="todo.no" v-bind:class="{checked: todo.cancelFlag}"
      @click="cancelTodo(todo.no)">{{todo.todo}} <span @click="deleteTodo(todo.no)" class="close">×</span></li>
  </ul>
</template>

<script>
  export default {
    props: ['todos'],
    methods: {
      cancelTodo(no) {
        this.$emit('cancel-todo', no);
      },
      deleteTodo(no) {
        this.$emit('delete-todo', no);
      }
    }
  }
</script>