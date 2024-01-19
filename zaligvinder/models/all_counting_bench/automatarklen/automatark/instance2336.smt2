(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([\r\n ]*//[^\r\n]*)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " "))) (str.to_re "//") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (str.to_re "\u{0a}")))))
; EFError\swww\u{2e}malware-stopper\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "EFError") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.malware-stopper.com\u{0a}")))))
; User-Agent\x3A\d+dll\x3F.*started\x2EfeedbackUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "dll?") (re.* re.allchar) (str.to_re "started.feedbackUser-Agent:\u{0a}"))))
; [\+]?[1]?[-. ]?(\(\d{3}\)|\d{3})(|[-. ])?\d{3}(|[-. ])\d{4}|\d{3}(|[-. ])\d{4}
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
