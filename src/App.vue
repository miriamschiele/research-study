<template>
  <Experiment title="magpie demo">
    <InstructionScreen :title="'Welcome'">
      In this study, a short description of a problem is displayed.
      Then, you are asked to come up with a method to solve the problem.
    </InstructionScreen>


    <TextareaScreen v-if="chooseQuestion() > 0.75" :options="randomOption()"
      question="In your opinion what does Addison need to do to reduce crime?"
      qud="Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500." />


    <TextareaScreen v-if="chooseQuestion() > 0.5 && chooseQuestion() <= 0.75" :options="randomOption()"
      question="In your opinion what does Addison need to do to reduce crime?"
      qud="Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500." />

    <TextareaScreen v-if="chooseQuestion() > 0.25 && chooseQuestion() <= 0.5" :options="randomOption()"
      question="In your opinion what does Addison need to do to reduce crime?" 
      qud=" Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. The rise in violent crime is particularly alarming." />

    <TextareaScreen v-if="chooseQuestion() <= 0.25" :options="randomOption()" 
      question="In your opinion what does Addison need to do to reduce crime?"
      qud="Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. The rise in violent crime is particularly alarming." />

    <Screen>
      <Slide >
        Please rate the reliability of the text.
        <RatingInput quid="Quelle" :right="'very reliable'" :left="'not reliable'" :response.sync="$magpie.measurements.rating" />

        <button @click="$magpie.saveAndNextScreen()">Submit</button>
      </Slide>
    </Screen>

    <ForcedChoiceScreen
    :options="['Democrat', 'Republican', 'neither', 'rather not say']"
    question="Please state your political affiliation."
/>

    <PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>

<script>
import _ from 'lodash';

export default {
  methods: {
    chooseQuestion: function () {
      console.log(this.random);
      return this.random;
    },
    randomOption: function () {
      const leftOption = this.options[Math.floor(Math.random() * this.options.length)];
      const rightOption = this.options.find(option => option !== leftOption);
      return [leftOption, rightOption]
    }
  },
  name: 'App',
  data() {
    return {
      options: [
        'Reform educational practices and create after school programs',
        'Increase street patrols that look for criminals'
      ],
      random: Math.random()
    };
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  }
};

</script>
