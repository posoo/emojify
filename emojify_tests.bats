#!/usr/bin/env bats

@test "handles an input without a single emoji 😿" {
  result=$(./emojify "no emoji :(")
  [ "$result" = "no emoji :(" ]
}

@test "handles an input with a single emoji 😹" {
  result=$(./emojify "an emoji :grin:")
  [ "$result" = "an emoji 😁" ]
}

@test "handles an input with a lot of emojis 😻" {
  result=$(./emojify "emojis :grin::grin: :tada:yay:champagne:")
  [ "$result" = "emojis 😁😁 🎉yay🍾" ]
}

@test "handles emojis with underscores and numbers 💯" {
  result=$(./emojify "this is perfect :100: :1st_place_medal:")
  [ "$result" = "this is perfect 💯 🥇" ]
}

@test "handles emojis with + and - 👍" {
  result=$(./emojify "great :+1::+1::-1:")
  [ "$result" = "great 👍👍👎" ]
}

@test "handles right-hand side emojis 👉" {
  result=$(./emojify ":not_an_emoji:point_right:")
  [ "$result" = ":not_an_emoji👉" ]
  result=$(./emojify "::::point_right:")
  [ "$result" = ":::👉" ]
}

@test "handles punctuations just after aliases" {
  result=$(./emojify "Enter the :airplane:!")
  [ "$result" = "Enter the ✈️!" ]
}

@test "ignores existing unicode emoji characters" {
  result=$(./emojify "🐛 leave the emojis alone!!")
  [ "$result" = "🐛 leave the emojis alone!!" ]
}

@test "handles multiple spaces after an emoji" {
  result=$(./emojify ":sparkles:   Three spaces")
  [ "$result" = "✨   Three spaces" ]
  result=$(./emojify ":sparkles:     Five spaces")
  [ "$result" = "✨     Five spaces" ]
  result=$(./emojify ":sparkles: One space")
  [ "$result" = "✨ One space" ]
}

@test "handles the examples from the readme 😉" {
  result=$(./emojify "Hey, I just :raising_hand: you, and this is :scream: , but here's my :calling: , so :telephone_receiver: me, maybe?")
  [ "$result" = "Hey, I just 🙋 you, and this is 😱 , but here's my 📲 , so 📞 me, maybe?" ]
  result=$(./emojify "To :bee: , or not to :bee: : that is the question... To take :muscle: against a :ocean: of troubles, and by opposing, end them?")
  [ "$result" = "To 🐝 , or not to 🐝 : that is the question... To take 💪 against a 🌊 of troubles, and by opposing, end them?" ]
}

@test "handles the list option" {
  emojis=$(./emojify -l | grep "2nd_place_medal")
  [ "$emojis" == ":2nd_place_medal: 🥈" ]
  emojis=$(./emojify --list | grep "2nd_place_medal")
  [ "$emojis" == ":2nd_place_medal: 🥈" ]
}

@test "handles the version option" {
  version=$(./emojify -v)
  [[ "$version" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]
  version=$(./emojify --version)
  [[ "$version" =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]
}
