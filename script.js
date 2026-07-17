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

  /* ---------- Inhoudsopgave in de aside ----------
     Gevuld vanuit de H2's die al op de pagina staan, zodat de lijst niet
     per pagina onderhouden hoeft te worden en nooit uit de pas kan lopen
     met de content. Staat JS uit, dan blijft .toc leeg en verbergt de CSS
     hem (.toc:empty) — er ontstaat dus geen kapot ogend blok. */
  var tocEl = document.querySelector(".toc");
  var proseEl = document.querySelector(".page-layout .prose");

  if (tocEl && proseEl) {
    var headings = Array.prototype.slice.call(proseEl.querySelectorAll("h2"));

    var slugify = function (text) {
      return text
        .toLowerCase()
        .replace(/[à-å]/g, "a")
        .replace(/[è-ë]/g, "e")
        .replace(/[ì-ï]/g, "i")
        .replace(/[ò-ö]/g, "o")
        .replace(/[ù-ü]/g, "u")
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
    };

    if (headings.length > 1) {
      var list = document.createElement("ol");
      var used = {};

      headings.forEach(function (h) {
        var id = h.id;
        if (!id) {
          id = slugify(h.textContent) || "sectie";
          // Voorkom dubbele ids bij gelijke koppen.
          if (used[id]) {
            used[id] += 1;
            id = id + "-" + used[id];
          } else {
            used[id] = 1;
          }
          h.id = id;
        }

        var li = document.createElement("li");
        var a = document.createElement("a");
        a.href = "#" + id;
        a.textContent = h.textContent;
        li.appendChild(a);
        list.appendChild(li);
      });

      var title = document.createElement("p");
      title.className = "toc-title";
      title.textContent = "Op deze pagina";
      tocEl.appendChild(title);
      tocEl.appendChild(list);

      // Markeer de kop die momenteel in beeld is.
      if ("IntersectionObserver" in window) {
        var links = {};
        Array.prototype.forEach.call(list.querySelectorAll("a"), function (a) {
          links[a.getAttribute("href").slice(1)] = a;
        });

        var setActive = function (id) {
          Object.keys(links).forEach(function (key) {
            links[key].classList.toggle("is-active", key === id);
          });
        };

        var spy = new IntersectionObserver(
          function (entries) {
            entries.forEach(function (entry) {
              if (entry.isIntersecting) {
                setActive(entry.target.id);
              }
            });
          },
          { rootMargin: "-90px 0px -70% 0px", threshold: 0 }
        );

        headings.forEach(function (h) {
          spy.observe(h);
        });
      }
    }
  }

  /* ---------- Jaartal footer ---------- */
  var yearEl = document.getElementById("year");
  if (yearEl) {
    yearEl.textContent = String(new Date().getFullYear());
  }

  /* ---------- Contactformulier (fetch → PHP-endpoint) ---------- */
  var form = document.getElementById("contact-form");
  var statusEl = document.getElementById("form-status");
  var submitBtn = document.getElementById("submit-btn");
  var submitLabel = document.getElementById("submit-label");
  var loadedAt = Date.now();

  var setStatus = function (message, ok) {
    if (!statusEl) return;
    statusEl.textContent = message;
    statusEl.hidden = false;
    statusEl.classList.toggle("is-error", !ok);
    statusEl.classList.toggle("is-ok", ok);
  };

  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      if (typeof form.reportValidity === "function" && !form.reportValidity()) {
        return;
      }

      var data = new FormData(form);
      data.append("elapsed", String(Date.now() - loadedAt));

      if (submitBtn) submitBtn.disabled = true;
      if (submitLabel) submitLabel.textContent = "Bezig met verzenden…";
      if (statusEl) statusEl.hidden = true;

      fetch(form.getAttribute("action") || "/api/contact.php", {
        method: "POST",
        headers: { Accept: "application/json" },
        body: data,
      })
        .then(function (res) {
          return res.json().then(function (json) {
            return { ok: res.ok, json: json };
          });
        })
        .then(function (result) {
          if (result.ok && result.json && result.json.success) {
            window.location.href = "/bedankt.html";
            return;
          }
          setStatus(
            (result.json && result.json.message) ||
              "Er ging iets mis bij het verzenden. Probeer het later opnieuw of mail direct naar info@secbv.nl.",
            false
          );
        })
        .catch(function () {
          setStatus(
            "Verzenden lukte niet. Controleer uw verbinding of mail direct naar info@secbv.nl.",
            false
          );
        })
        .finally(function () {
          if (submitBtn) submitBtn.disabled = false;
          if (submitLabel) submitLabel.textContent = "Verstuur bericht";
        });
    });
  }
})();
