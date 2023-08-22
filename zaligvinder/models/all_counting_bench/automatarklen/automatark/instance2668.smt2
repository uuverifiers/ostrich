(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Windows\x2Fclient\x2FBlackreportc\.goclick\.comX-Sender\x3A
(assert (str.in_re X (str.to_re "Windows/client/Blackreportc.goclick.comX-Sender:\u{13}\u{0a}")))
; /filename=[^\n]*\u{2e}webm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".webm/i\u{0a}"))))
; ^(\d{4}((-)?(0[1-9]|1[0-2])((-)?(0[1-9]|[1-2][0-9]|3[0-1])(T(24:00(:00(\.[0]+)?)?|(([0-1][0-9]|2[0-3])(:)[0-5][0-9])((:)[0-5][0-9](\.[\d]+)?)?)((\+|-)(14:00|(0[0-9]|1[0-3])(:)[0-5][0-9])|Z))?)?)?)$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.opt (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.opt (re.++ (str.to_re "T") (re.union (re.++ (str.to_re "24:00") (re.opt (re.++ (str.to_re ":00") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))))) (re.++ (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.union (re.++ (re.union (str.to_re "+") (str.to_re "-")) (re.union (str.to_re "14:00") (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9")))) (str.to_re "Z"))))))))))))
(assert (> (str.len X) 10))
(check-sat)
