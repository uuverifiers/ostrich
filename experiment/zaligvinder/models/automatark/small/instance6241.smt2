(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\(([1-9]{2})\))(\s)?(\.)?(\-)?([0-9]{0,1})?([0-9]{4})(\s)?(\.)?(\-)?([0-9]{4})|(([1-9]{2}))(\s)?(\.)?(\-)?([0-9]{0,1})?([0-9]{4})(\s)?(\.)?(\-)?([0-9]{4}))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) (re.opt (re.opt (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ")")) (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) (re.opt (re.opt (re.range "0" "9"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re ".")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; YOURHost\x3Awww\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (str.to_re "YOURHost:www.alfacleaner.com\u{0a}")))
; PromulGate\s+SbAts.*Uservclxatmlhavj\u{2f}vsywww\x2Evip-se\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "PromulGate") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.* re.allchar) (str.to_re "Uservclxatmlhavj/vsywww.vip-se.com\u{13}\u{0a}")))))
; Server\s+www\x2Epeer2mail\x2Ecomsubject\x3AfileId\u{3d}\u{5b}
(assert (str.in_re X (re.++ (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.comsubject:fileId=[\u{0a}"))))
(check-sat)
