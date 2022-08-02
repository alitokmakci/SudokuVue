<template>
  <div
    class="cursor-pointer h-16 w-16 flex border-t border-l items-center justify-center border-black"
    :class="{
      'border-r-[3px]': index % 9 === 8 || index % 9 === 2 || index % 9 === 5,
      'border-l-[3px]': index % 9 === 0,
      'border-t-[3px]': index < 9,
      'border-b-[3px]': bottom,
      'bg-sky-50': dark && !selected && !isWrong,
      'bg-white': !dark && !selected && !isWrong,
      'bg-blue-600 hover:bg-blue-800 text-white': selected,
      'hover:bg-blue-200': !selected,
      'bg-red-500 text-white': isWrong && !selected,
      'bg-purple-500': isWrong && selected,
      'bg-green-400 text-white': isCorrect,
      'text-gray-500': hint,
    }"
    @click="handleClick"
  >
    <span class="text-4xl select-none">{{ value === "." ? "" : value }}</span>
  </div>
</template>

<script setup>
import { computed } from "vue";

const { index, value, selected, isWrong, isCorrect } = defineProps({
  value: {
    type: [String, Number],
    default: ".",
  },
  index: {
    type: Number,
    default: 0,
  },
  selected: {
    type: Boolean,
    default: false,
  },
  isWrong: {
    type: Boolean,
    default: false,
  },
  isCorrect: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(["select"]);

const hint = computed(() => {
  return value !== ".";
});

const bottom = computed(() => {
  if (index >= 18 && index <= 26) {
    return true;
  }

  if (index >= 45 && index <= 53) {
    return true;
  }

  if (index >= 72 && index <= 80) {
    return true;
  }

  return false;
});

const dark = computed(() => {
  if (index < 27 && index % 9 < 3) {
    return true;
  }

  if (index >= 54 && index % 9 < 3) {
    return true;
  }

  if (index < 27 && index % 9 > 5) {
    return true;
  }

  if (index >= 54 && index % 9 > 5) {
    return true;
  }

  if (index < 54 && index > 26 && index % 9 > 2 && index % 9 < 6) {
    return true;
  }

  return false;
});

const handleClick = () => {
  if (!hint.value) {
    emit("select", index);
  } else {
    emit("select", null);
  }
};
</script>
