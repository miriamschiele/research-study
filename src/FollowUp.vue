<template>
  <Experiment title="Study on problem solving">
    <InstructionScreen :title="'Welcome'">
      In this study, you are asked to come up with a method to solve a problem.

      <br>

      Concretely, you will first have to read a background scenario. 
      Please read it very carefully. 
      Afterwards, you will be asked to come up with a potential solution to the problem described in said scenario. 
      Finally, you will be asked to rate the reliability of the information presented in the background scenario.
    </InstructionScreen>

    <Screen :validations="{
      response: {
        minLength: $magpie.v.minLength(5),
        required: $magpie.v.required
      }
    }">

      <Slide>
        <Record :data="{
              group: group,
              task: 'solution'
              }" />
        <p><div style='color:gray'>Background scenario</div></p>
        <p><strong>Please read what this person has to say about the current situation in the City of Addison.</strong></p>
        <template>
          <img v-bind:src="require(`${background}`)" />
        </template>

        <p><div style='color:gray'>Question</div></p>
        <p><strong>In your opinion what does Addison need to do to reduce crime?</strong></p>
        <TextareaInput
            :response.sync= "$magpie.measurements.response"
          />
          <button v-if="!$magpie.validateMeasurements.response.$invalid" @click="$magpie.saveAndNextScreen();">Continue</button>
      </Slide>

    </Screen>

    
    <Screen :validations="{
      response: {
        required: $magpie.v.required
      }
    }">
      <Slide >
        <Record :data="{
              group: group,
              task: 'reliability'
              }" />
        Please rate the reliability of the speaker.
        <RatingInput quid="Quelle" :right="'very reliable'" :left="'not reliable'" :response.sync="$magpie.measurements.response" />

        <button v-if="!$magpie.validateMeasurements.response.$invalid" @click="$magpie.saveAndNextScreen()">Submit</button>

      </Slide>
    </Screen>

    <Screen>

      <Slide>
        <Record :data="{
              group: group,
              task: 'affiliation'
              }" />
        <p>Please state your political affiliation.</p>
        <ForcedChoiceInput
            :response.sync= "$magpie.measurements.response"
            :options="['Democrat', 'Republican', 'neither', 'rather not say']"
          @update:response="$magpie.saveAndNextScreen();"/>
      </Slide>

    </Screen>


    <PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>

<script>
import _ from 'lodash';


// determine group

var group = _.shuffle(["beast, reliable", "virus, reliable", "beast, unreliable", "virus, unreliable"])[0] 

var backgrounds = {
    "beast, reliable": "./assets/beast, reliable.png",
    "virus, reliable": "./assets/virus, reliable.png",
    "beast, unreliable": "./assets/beast, unreliable.png",
    "virus, unreliable": "./assets/virus, unreliable.png",
}

var background = backgrounds[group]

console.log(background)

export default {
  methods: {
    chooseQuestion: function () {
      return this.random;
    },
    randomOption: function () {
      const leftOption = this.options[Math.floor(Math.random() * this.options.length)];
      const rightOption = this.options.find(option => option !== leftOption);
      return [leftOption, rightOption]
    }
  },
  name: 'FollowUp',
  data() {
    return {
        group: group,
        background: background,
      options: [
        'Reform educational practices and create after school programs',
        'Increase street patrols that look for criminals'
      ],
      random: Math.random(),
      disableButton: true
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
