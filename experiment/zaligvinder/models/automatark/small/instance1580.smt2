(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^syn\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/syn|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; (refs|references|re|closes|closed|close|see|fixes|fixed|fix|addresses) #(\d+)(( and |, | & | )#(\d+))*
(assert (not (str.in_re X (re.++ (re.union (str.to_re "refs") (str.to_re "references") (str.to_re "re") (str.to_re "closes") (str.to_re "closed") (str.to_re "close") (str.to_re "see") (str.to_re "fixes") (str.to_re "fixed") (str.to_re "fix") (str.to_re "addresses")) (str.to_re " #") (re.+ (re.range "0" "9")) (re.* (re.++ (re.union (str.to_re " and ") (str.to_re ", ") (str.to_re " & ") (str.to_re " ")) (str.to_re "#") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
