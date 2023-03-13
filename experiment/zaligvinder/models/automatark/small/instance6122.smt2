(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^N[1-9][0-9]{0,4}$|^N[1-9][0-9]{0,3}[A-Z]$|^N[1-9][0-9]{0,2}[A-Z]{2}$
(assert (str.in_re X (re.++ (str.to_re "N") (re.range "1" "9") (re.union ((_ re.loop 0 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.range "A" "Z")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))))
; (^([0-9]*[.][0-9]*[1-9]+[0-9]*)$)|(^([0-9]*[1-9]+[0-9]*[.][0-9]+)$)|(^([1-9]+[0-9]*)$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))))))
; dist\x2Eatlas\x2Dia\x2EcomSpy\-LockedOnlineconnection
(assert (not (str.in_re X (str.to_re "dist.atlas-ia.comSpy-LockedOnlineconnection\u{0a}"))))
(check-sat)
