/* =========================================================
   S.E.C. B.V. — kleine, vanilla JS voor interactie
   - Mobiel menu (openen/sluiten)
   - Scroll-reveal animaties (respecteert reduced-motion)
   - Jaartal in de footer
   ========================================================= */
(function () {
  "use strict";

  /* ---------- Mobiel menu ---------- */
  var toggle = document.getElementById("nav-toggle");
  var nav = document.getElementById("primary-nav");

  if (toggle && nav) {
    var closeMenu = function () {
      nav.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");
      toggle.setAttribute("aria-label", "Menu openen");
    };
    var openMenu = function () {
      nav.classList.add("is-open");
      toggle.setAttribute("aria-expanded", "true");
      toggle.setAttribute("aria-label", "Menu sluiten");
    };

    toggle.addEventListener("click", function () {
      var open = toggle.getAttribute("aria-expanded") === "true";
      if (open) {
        closeMenu();
      } else {
        openMenu();
      }
    });

    // Sluit het menu na het kiezen van een link
    nav.addEventListener("click", function (e) {
      if (e.target.closest("a")) {
        closeMenu();
      }
    });

    // Sluit met Escape
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") {
        closeMenu();
      }
    });
  }

  /* ---------- Scroll-reveal ---------- */
  var reduceMotion = window.matchMedia(
    "(prefers-reduced-motion: reduce)"
  ).matches;

  var revealTargets = document.querySelectorAll(
    ".section-head, .card, .step, .benefit, .reason, .sectors li, .intro-card, .feature-panel, .contact-card"
  );

  if (!reduceMotion && "IntersectionObserver" in window) {
    revealTargets.forEach(function (el) {
      el.classList.add("reveal");
    });

    var observer = new IntersectionObserver(
      function (entries, obs) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            obs.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
    );

    revealTargets.forEach(function (el) {
      observer.observe(el);
    });
  }

  /* ---------- Jaartal footer ---------- */
  var yearEl = document.getElementById("year");
  if (yearEl) {
    yearEl.textContent = String(new Date().getFullYear());
  }
})();
