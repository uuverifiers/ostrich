(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; %[\-\+0\s\#]{0,1}(\d+){0,1}(\.\d+){0,1}[hlI]{0,1}[cCdiouxXeEfgGnpsS]{1}
(assert (str.in_re X (re.++ (str.to_re "%") (re.opt (re.union (str.to_re "-") (str.to_re "+") (str.to_re "0") (str.to_re "#") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (re.opt (re.union (str.to_re "h") (str.to_re "l") (str.to_re "I"))) ((_ re.loop 1 1) (re.union (str.to_re "c") (str.to_re "C") (str.to_re "d") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "x") (str.to_re "X") (str.to_re "e") (str.to_re "E") (str.to_re "f") (str.to_re "g") (str.to_re "G") (str.to_re "n") (str.to_re "p") (str.to_re "s") (str.to_re "S"))) (str.to_re "\u{0a}"))))
; ^A([0-9]|10)$
(assert (str.in_re X (re.++ (str.to_re "A") (re.union (re.range "0" "9") (str.to_re "10")) (str.to_re "\u{0a}"))))
; [^ _0-9a-zA-Z\$\%\'\-\@\{\}\~\!\#\(\)\&\^]
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "_") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "$") (str.to_re "%") (str.to_re "'") (str.to_re "-") (str.to_re "@") (str.to_re "{") (str.to_re "}") (str.to_re "~") (str.to_re "!") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "&") (str.to_re "^")) (str.to_re "\u{0a}"))))
; MailerHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "MailerHost:User-Agent:\u{0a}"))))
; ([^\w]+)|([^A-Za-z])|(\b[^aeiouy]+\b)|(\b(\w{2})\b)
(assert (str.in_re X (re.union (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "y"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")) (re.range "A" "Z") (re.range "a" "z"))))
(assert (> (str.len X) 10))
(check-sat)
