(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0](\d{9})|([0](\d{2})( |-)((\d{3}))( |-)(\d{4}))|[0](\d{2})( |-)(\d{7})
(assert (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ['`~!@#&$%^&*()-_=+{}|?><,.:;{}\"\\/\\[\\]]
(assert (str.in_re X (re.++ (re.union (str.to_re "'") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "&") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "*") (str.to_re "(") (re.range ")" "_") (str.to_re "=") (str.to_re "+") (str.to_re "{") (str.to_re "}") (str.to_re "|") (str.to_re "?") (str.to_re ">") (str.to_re "<") (str.to_re ",") (str.to_re ".") (str.to_re ":") (str.to_re ";") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "[")) (str.to_re "]\u{0a}"))))
; User-Agent\x3A\d+dll\x3F.*started\x2EfeedbackUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.* re.allchar) (str.to_re "started.feedbackUser-Agent:\u{0a}")))))
; ^[ 1(]{0,3}?([02-9][0-9]{2})\D{0,2}([0-9]{3})\D?([0-9]{4})($|\D+.+$)
(assert (not (str.in_re X (re.++ ((_ re.loop 0 3) (re.union (str.to_re " ") (str.to_re "1") (str.to_re "("))) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.comp (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.union (str.to_re "0") (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.+ (re.comp (re.range "0" "9"))) (re.+ re.allchar)))))
; ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
