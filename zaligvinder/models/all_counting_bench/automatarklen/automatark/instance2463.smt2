(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wowokayoffers\x2Ebullseye-network\x2EcomRTB\x0D\x0A\x0D\x0AAttached
(assert (str.in_re X (str.to_re "wowokayoffers.bullseye-network.comRTB\u{0d}\u{0a}\u{0d}\u{0a}Attached\u{0a}")))
; TOOLBAR\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "TOOLBAR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}"))))
; (^\+?([1-8])?\d(\.\d+)?$)|(^-90$)|(^-(([1-8])?\d(\.\d+)?$))
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (re.opt (re.range "1" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "-90") (re.++ (str.to_re "\u{0a}-") (re.opt (re.range "1" "8")) (re.range "0" "9") (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))))))
; /^[0-9]\d{2,4}-\d{6,8}$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "0" "9") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
