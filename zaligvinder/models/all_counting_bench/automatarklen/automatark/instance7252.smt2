(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; aohobygi\u{2f}zwiw\s+\+The\+password\+is\x3A
(assert (not (str.in_re X (re.++ (str.to_re "aohobygi/zwiw") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "+The+password+is:\u{0a}")))))
; ^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$
(assert (str.in_re X (re.++ (str.to_re "http://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}"))))
; /PRIVMSG #new :\u{02}\u{5b}(GOOGLE|SCAN)\u{5d}\u{02}\u{20}Scanning/
(assert (str.in_re X (re.++ (str.to_re "/PRIVMSG #new :\u{02}[") (re.union (str.to_re "GOOGLE") (str.to_re "SCAN")) (str.to_re "]\u{02} Scanning/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
