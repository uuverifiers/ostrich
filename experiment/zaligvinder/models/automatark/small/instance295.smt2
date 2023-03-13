(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jmh/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jmh/i\u{0a}"))))
; ^[-]?([1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|\.[0-9]{1,2})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (\<\?php\s+.*?((\?\>)|$))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}<?php") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar) (str.to_re "?>"))))
; log\=\x7BIP\x3AIP-PortaURLSSKC\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPalToolbarUser-Agent\x3A
(assert (str.in_re X (str.to_re "log={IP:IP-PortaURLSSKC|roogoo|.cfgmPOPrtCUSTOMPalToolbarUser-Agent:\u{0a}")))
; /^([A-Za-z0-9+\u{2f}]{4})*([A-Za-z0-9+\u{2f}]{4}|[A-Za-z0-9+\u{2f}]{3}=|[A-Za-z0-9+\u{2f}]{2}==)$/mP
(assert (str.in_re X (re.++ (str.to_re "/") (re.* ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/")))) (re.union ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=")) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=="))) (str.to_re "/mP\u{0a}"))))
(check-sat)
