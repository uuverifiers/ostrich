(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-z0-9][a-z0-9_\.-]{0,}[a-z0-9]\.[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9][\.][cn]{2,4}
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 4) (re.union (str.to_re "c") (str.to_re "n"))) (str.to_re "\u{0a}"))))
; \A(([a-zA-Z]{1,2}\d{1,2})|([a-zA-Z]{2}\d[a-zA-Z]{1}))\u{20}{0,1}\d[a-zA-Z]{2}\Z
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (str.to_re " ")) (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^([(][1-9]{2}[)] )?[0-9]{4}[-]?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ") "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; dist\x2Eatlas\x2Dia\x2EcomSpy\-LockedOnlineconnection
(assert (not (str.in_re X (str.to_re "dist.atlas-ia.comSpy-LockedOnlineconnection\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
