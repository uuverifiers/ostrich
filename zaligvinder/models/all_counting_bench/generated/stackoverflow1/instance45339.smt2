;test regex perl -0777 -i -pe "s/(\-name[\t ]*riak\@)[^\n]+/\${1}$riak_ip/g" vm.args
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "0777") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "i") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.++ (str.to_re "-") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (re.* (re.union (str.to_re "\u{09}") (str.to_re " "))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "k") (str.to_re "@"))))))))))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "/") ((_ re.loop 1 1) (str.to_re "$"))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "k") (re.++ (str.to_re "_") (re.++ (str.to_re "i") (re.++ (str.to_re "p") (re.++ (str.to_re "/") (re.++ (str.to_re "g") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "v") (re.++ (str.to_re "m") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "g") (str.to_re "s"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)