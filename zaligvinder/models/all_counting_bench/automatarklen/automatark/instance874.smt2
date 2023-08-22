(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; stats\u{2e}drivecleaner\u{2e}comExciteasdbiz\x2Ebiz
(assert (str.in_re X (str.to_re "stats.drivecleaner.com\u{13}Exciteasdbiz.biz\u{0a}")))
; /filename=[^\n]*\u{2e}xwd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xwd/i\u{0a}"))))
; ^[A-Z0-9a-z'&()/]{0,1}[A-Z0-9a-z'&()/]{0,1}(([A-Z0-9a-z'&()/_-])|(\\s)){0,47}[A-Z0-9a-z'&()/]{1}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) ((_ re.loop 0 47) (re.union (str.to_re "\u{5c}s") (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
