(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\dName=Your\+Host\+is\x3A.*has\s+ComputerKeylogger\x2EcomHost\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Name=Your+Host+is:") (re.* re.allchar) (str.to_re "has") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ComputerKeylogger.comHost:\u{0a}"))))
; 3[47]\d{13}
(assert (str.in_re X (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; twfofrfzlugq\u{2f}eve\.qd\d+
(assert (str.in_re X (re.++ (str.to_re "twfofrfzlugq/eve.qd") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; adserver\.warezclient\.com\s+URLBlaze\s+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "adserver.warezclient.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlaze") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}")))))
; [({]?(0x)?[0-9a-fA-F]{8}([-,]?(0x)?[0-9a-fA-F]{4}){2}((-?[0-9a-fA-F]{4}-?[0-9a-fA-F]{12})|(,\{0x[0-9a-fA-F]{2}(,0x[0-9a-fA-F]{2}){7}\}))[)}]?
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "(") (str.to_re "{"))) (re.opt (str.to_re "0x")) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 2 2) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ","))) (re.opt (str.to_re "0x")) ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))) (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re ",{0x") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 7 7) (re.++ (str.to_re ",0x") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))) (str.to_re "}"))) (re.opt (re.union (str.to_re ")") (str.to_re "}"))) (str.to_re "\u{0a}")))))
(check-sat)
