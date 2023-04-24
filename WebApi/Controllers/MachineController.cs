using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MachineController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()

        {
            MachineDetails machineDetials = new MachineDetails();

            machineDetials.machineName = Environment.MachineName;

            machineDetials.machineIP = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            machineDetials.machineOS = Environment.OSVersion.VersionString;

            machineDetials.timestamp = DateTime.Now.ToString();

            return Ok(machineDetials);





        }
    }
}
