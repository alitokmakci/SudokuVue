<template>
  <div
    v-if="play"
    class="h-screen w-screen flex items-center justify-center flex-col"
  >
    <Row v-for="row in rows" :index="row" :key="row">
      <Cell
        v-for="col in columns"
        :key="9 * row + col"
        :value="problem[9 * row + col]"
        :index="9 * row + col"
        @select="handleCellSelect"
        :selected="selectedCell == 9 * row + col"
        :is-wrong="errors.includes(9 * row + col)"
        :is-correct="corrects.includes(9 * row + col)"
      />
    </Row>

    <div class="mt-10">
      <button
        @click="finishGame"
        class="bg-blue-500 px-4 py-2 rounded text-white active:bg-blue-500 hover:bg-blue-600"
      >
        I Solved It !!
      </button>
    </div>
  </div>
  <div v-else class="h-screen w-screen flex items-center justify-center">
    <button
      class="bg-blue-500 px-4 py-2 rounded text-white active:bg-blue-500 hover:bg-blue-600"
      @click="startGame"
    >
      Let's Play Sudoku
    </button>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import Row from "./components/Row.vue";
import Cell from "./components/Cell.vue";
import axios from "axios";
import Swal from "sweetalert2";

const rows = [0, 1, 2, 3, 4, 5, 6, 7, 8];
const columns = [0, 1, 2, 3, 4, 5, 6, 7, 8];

const play = ref(false);
const checked = ref(false);
const problem = ref([]);
const solution = ref([]);
const selectedCell = ref(null);
const errors = ref([]);
const corrects = ref([]);

const handleCellSelect = (index) => {
  if (selectedCell.value === index) {
    selectedCell.value = null;
  } else {
    selectedCell.value = index;
  }
};

const startGame = () => {
  errors.value = [];
  corrects.value = [];
  axios.get("https://mighty-meadow-02197.herokuapp.com/problems/random").then((res) => {
    problem.value = res.data.schema.split("");
    solution.value = res.data.solution.split("");
    play.value = true;
  });
};

onMounted(() => {
  document.addEventListener("keyup", (e) => {
    handleKeyPressed(e.key);
  });
});

const isNumeric = (value) => {
  return /^-?\d+$/.test(value);
};

const handleKeyPressed = (num) => {
  if (selectedCell.value === null) {
    return;
  }

  const index = selectedCell.value;

  if (num === "Backspace") {
    problem.value[index] = ".";

    return;
  }

  if (!isNumeric(num) || num === "0") {
    return;
  }

  const value = problem.value[index];

  if (value !== ".") {
    return;
  }

  problem.value[index] = num;
};

const finishGame = () => {
  errors.value = [];
  checked.value = true;
  for (let i = 0; i < problem.value.length; i++) {
    if (!isNumeric(problem.value[i])) {
      console.log(problem.value[i]);
      errors.value.push(i);
    } else {
      if (parseInt(problem.value[i]) !== parseInt(solution.value[i])) {
        errors.value.push(i);
      } else {
        corrects.value.push(i);
      }
    }
  }

  if (errors.value.length === 0) {
    Swal.fire({
      title: "Congratulations!",
      text: "You have solved the puzzle!",
      icon: "success",
      confirmButtonText: "Play Again",
    }).then((result) => {
      if (result.value) {
        startGame();
      }
    });
  } else {
    Swal.fire({
      title: "Oops...",
      text: "You have some errors!",
      icon: "error",
      confirmButtonText: "Try Again",
    });
  }
};
</script>
