(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}caf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".caf/i\u{0a}"))))
; /Referer\u{3a}[^\n]*fla\.php\?wq=[a-f0-9]+\u{0d}\u{0a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/Referer:") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "fla.php?wq=") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
; ^(([0-9]{1})|([0-9]{1}[0-9]{1})|([1-3]{1}[0-6]{1}[0-5]{1}))d(([0-9]{1})|(1[0-9]{1})|([1-2]{1}[0-3]{1}))h(([0-9]{1})|([1-5]{1}[0-9]{1}))m$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "3")) ((_ re.loop 1 1) (re.range "0" "6")) ((_ re.loop 1 1) (re.range "0" "5")))) (str.to_re "d") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re "h") (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "m\u{0a}")))))
; /\u{2f}\?ts\u{3d}[a-f0-9]{40}\u{26}/Ui
(assert (str.in_re X (re.++ (str.to_re "//?ts=") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&/Ui\u{0a}"))))
; ^\s+|\s+$
(assert (not (str.in_re X (re.union (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
